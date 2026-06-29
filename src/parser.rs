use crate::ast::*;
use crate::error::{XError, XResult};
use crate::lexer::{Token, TokenKind};
use crate::source::{Span, Spanned};

pub struct Parser {
    tokens: Vec<Token>,
    i: usize,
    file: String,
    file_id: u32,
    /// Byte offset just past the most recently consumed token; lets a saved
    /// start offset be turned into a span via `span_from(start)`.
    last_end: u32,
}

impl Parser {
    pub(crate) fn new(tokens: Vec<Token>, file: impl Into<String>) -> Self {
        Self {
            tokens,
            i: 0,
            file: file.into(),
            file_id: 0,
            last_end: 0,
        }
    }

    pub fn parse(&mut self) -> XResult<Program> {
        let module = self.parse_module_decl()?;
        let mut imports = Vec::new();
        while self.check("import") {
            imports.push(self.parse_import_decl()?);
        }

        let mut items = Vec::new();
        while !self.is_eof() {
            items.push(self.parse_item()?);
        }

        Ok(Program {
            kind: "Program",
            module,
            imports,
            items,
        })
    }

    fn peek(&self) -> &Token {
        &self.tokens[self.i.min(self.tokens.len() - 1)]
    }

    fn is_eof(&self) -> bool {
        self.peek().kind == TokenKind::Eof
    }

    fn check(&self, text: &str) -> bool {
        self.peek().text == text
    }

    fn cur_start(&self) -> u32 {
        self.peek().start
    }

    fn span_from(&self, start: u32) -> Span {
        Span::new(self.file_id, start, self.last_end)
    }

    fn bump(&mut self) -> Token {
        let tok = self.peek().clone();
        self.last_end = tok.end;
        self.i += 1;
        tok
    }

    fn match_text(&mut self, text: &str) -> bool {
        if self.check(text) {
            let tok = self.peek().clone();
            self.last_end = tok.end;
            self.i += 1;
            true
        } else {
            false
        }
    }

    fn expect(&mut self, text: &str) -> XResult<Token> {
        if self.check(text) {
            Ok(self.bump())
        } else {
            let tok = self.peek();
            Err(XError::Parse(format!(
                "expected {text:?}, got {:?} at {}:{}:{}",
                tok.text, self.file, tok.line, tok.col
            )))
        }
    }

    fn expect_ident(&mut self) -> XResult<Token> {
        let tok = self.peek();
        if tok.kind == TokenKind::Ident {
            Ok(self.bump())
        } else {
            Err(XError::Parse(format!(
                "expected identifier, got {:?} at {}:{}:{}",
                tok.text, self.file, tok.line, tok.col
            )))
        }
    }

    fn parse_module_decl(&mut self) -> XResult<ModuleDecl> {
        self.expect("module")?;
        Ok(ModuleDecl {
            kind: "ModuleDecl",
            path: self.parse_path()?,
        })
    }

    fn parse_import_decl(&mut self) -> XResult<ImportDecl> {
        self.expect("import")?;
        Ok(ImportDecl {
            kind: "ImportDecl",
            path: self.parse_path()?,
        })
    }

    fn parse_path(&mut self) -> XResult<Vec<String>> {
        let mut parts = vec![self.expect_ident()?.text];
        while self.match_text(".") {
            parts.push(self.expect_ident()?.text);
        }
        Ok(parts)
    }

    fn parse_item(&mut self) -> XResult<Spanned<Item>> {
        let start = self.cur_start();
        let node = if self.check("struct") {
            self.parse_struct_decl()?
        } else if self.check("type") {
            self.parse_type_alias()?
        } else if self.check("fn") {
            self.parse_fn_decl()?
        } else {
            let tok = self.peek();
            return Err(XError::Parse(format!(
                "expected item, got {:?} at {}:{}:{}",
                tok.text, self.file, tok.line, tok.col
            )));
        };
        Ok(Spanned::new(node, self.span_from(start)))
    }

    fn parse_struct_decl(&mut self) -> XResult<Item> {
        self.expect("struct")?;
        let name = self.expect_ident()?.text;
        self.expect("{")?;
        let mut fields = Vec::new();
        while !self.check("}") {
            let field_name = self.expect_ident()?.text;
            self.expect(":")?;
            let ty = self.parse_type_expr()?;
            fields.push(FieldDecl {
                kind: "FieldDecl",
                name: field_name,
                ty,
            });
        }
        self.expect("}")?;
        Ok(Item::StructDecl { name, fields })
    }

    fn parse_type_alias(&mut self) -> XResult<Item> {
        self.expect("type")?;
        let name = self.expect_ident()?.text;
        self.expect("=")?;
        let ty = self.parse_type_expr()?;
        Ok(Item::TypeAliasDecl { name, ty })
    }

    fn parse_fn_decl(&mut self) -> XResult<Item> {
        self.expect("fn")?;
        let name = self.expect_ident()?.text;
        self.expect("(")?;
        let mut params = Vec::new();
        if !self.check(")") {
            params.push(self.parse_param()?);
            while self.match_text(",") {
                params.push(self.parse_param()?);
            }
        }
        self.expect(")")?;
        self.expect(":")?;
        let return_type = self.parse_type_expr()?;
        let body = self.parse_block()?;
        Ok(Item::FnDecl {
            name,
            params,
            return_type,
            body,
        })
    }

    fn parse_param(&mut self) -> XResult<Param> {
        let name = self.expect_ident()?.text;
        self.expect(":")?;
        let ty = self.parse_type_expr()?;
        Ok(Param {
            kind: "Param",
            name,
            ty,
        })
    }

    fn parse_type_expr(&mut self) -> XResult<TypeNode> {
        let name = self.expect_ident()?.text;
        let mut args = Vec::new();
        if self.match_text("<") {
            args.push(self.parse_type_arg()?);
            while self.match_text(",") {
                args.push(self.parse_type_arg()?);
            }
            self.expect(">")?;
        }
        Ok(TypeNode::TypeExpr { name, args })
    }

    fn parse_type_arg(&mut self) -> XResult<TypeNode> {
        if self.peek().kind == TokenKind::Int {
            return Ok(TypeNode::ConstTypeArg {
                value: self.bump().text,
            });
        }
        self.parse_type_expr()
    }

    fn parse_block(&mut self) -> XResult<Block> {
        self.expect("{")?;
        let mut statements = Vec::new();
        while !self.check("}") {
            if self.is_eof() {
                let tok = self.peek();
                return Err(XError::Parse(format!(
                    "unterminated block at {}:{}:{}",
                    self.file, tok.line, tok.col
                )));
            }
            statements.push(self.parse_stmt()?);
        }
        self.expect("}")?;
        Ok(Block {
            kind: "Block",
            statements,
        })
    }

    fn parse_stmt(&mut self) -> XResult<Spanned<Stmt>> {
        if self.check("let") {
            self.parse_let_stmt()
        } else if self.check("if") {
            self.parse_if_stmt()
        } else if self.check("for") {
            self.parse_for_stmt()
        } else if self.check("while") {
            self.parse_while_stmt()
        } else if self.check("match") {
            self.parse_match_stmt()
        } else if self.check("return") {
            self.parse_return_stmt()
        } else if self.check("break") {
            let start = self.cur_start();
            self.expect("break")?;
            Ok(Spanned::new(Stmt::BreakStmt, self.span_from(start)))
        } else if self.check("continue") {
            let start = self.cur_start();
            self.expect("continue")?;
            Ok(Spanned::new(Stmt::ContinueStmt, self.span_from(start)))
        } else {
            let start = self.cur_start();
            let expr = self.parse_expr()?;
            Ok(Spanned::new(Stmt::ExprStmt { expr }, self.span_from(start)))
        }
    }

    fn parse_let_stmt(&mut self) -> XResult<Spanned<Stmt>> {
        let start = self.cur_start();
        self.expect("let")?;
        let mutable = self.match_text("mut");
        let name = self.expect_ident()?.text;
        self.expect(":")?;
        let ty = self.parse_type_expr()?;
        self.expect("=")?;
        let value = self.parse_expr()?;
        Ok(Spanned::new(
            Stmt::LetStmt {
                mutable,
                name,
                ty,
                value,
            },
            self.span_from(start),
        ))
    }

    fn parse_if_stmt(&mut self) -> XResult<Spanned<Stmt>> {
        let start = self.cur_start();
        self.expect("if")?;
        let condition = self.parse_expr()?;
        let then_block = self.parse_block()?;
        let else_branch = if self.match_text("else") {
            if self.check("if") {
                Some(ElseBranch::IfStmt(Box::new(self.parse_if_stmt()?)))
            } else {
                Some(ElseBranch::Block(self.parse_block()?))
            }
        } else {
            None
        };
        Ok(Spanned::new(
            Stmt::IfStmt {
                condition,
                then_block,
                else_branch,
            },
            self.span_from(start),
        ))
    }

    fn parse_for_stmt(&mut self) -> XResult<Spanned<Stmt>> {
        let start = self.cur_start();
        self.expect("for")?;
        let iterator = self.expect_ident()?.text;
        self.expect("in")?;
        let iterable = self.parse_expr()?;
        let body = self.parse_block()?;
        Ok(Spanned::new(
            Stmt::ForStmt {
                iterator,
                iterable,
                body,
            },
            self.span_from(start),
        ))
    }

    fn parse_while_stmt(&mut self) -> XResult<Spanned<Stmt>> {
        let start = self.cur_start();
        self.expect("while")?;
        let condition = self.parse_expr()?;
        let body = self.parse_block()?;
        Ok(Spanned::new(
            Stmt::WhileStmt { condition, body },
            self.span_from(start),
        ))
    }

    fn parse_match_stmt(&mut self) -> XResult<Spanned<Stmt>> {
        let start = self.cur_start();
        self.expect("match")?;
        let value = self.parse_expr()?;
        self.expect("{")?;
        let mut arms = Vec::new();
        while !self.check("}") {
            let pattern = self.parse_pattern()?;
            self.expect("=>")?;
            let body = self.parse_block()?;
            arms.push(MatchArm {
                kind: "MatchArm",
                pattern,
                body,
            });
        }
        self.expect("}")?;
        Ok(Spanned::new(
            Stmt::MatchStmt { value, arms },
            self.span_from(start),
        ))
    }

    fn parse_pattern(&mut self) -> XResult<Pattern> {
        let name = self.expect_ident()?.text;
        let mut bindings = Vec::new();
        if self.match_text("(") {
            if !self.check(")") {
                bindings.push(self.expect_ident()?.text);
                while self.match_text(",") {
                    bindings.push(self.expect_ident()?.text);
                }
            }
            self.expect(")")?;
        }
        Ok(Pattern::VariantPattern { name, bindings })
    }

    fn parse_return_stmt(&mut self) -> XResult<Spanned<Stmt>> {
        let start = self.cur_start();
        self.expect("return")?;
        let value = if self.check("}") {
            None
        } else {
            Some(self.parse_expr()?)
        };
        Ok(Spanned::new(
            Stmt::ReturnStmt { value },
            self.span_from(start),
        ))
    }

    fn parse_expr(&mut self) -> XResult<Spanned<Expr>> {
        self.parse_assignment()
    }

    fn parse_assignment(&mut self) -> XResult<Spanned<Expr>> {
        let expr = self.parse_logical_or()?;
        if self.match_text("=") {
            let value = self.parse_assignment()?;
            let span = expr.span.merge(value.span);
            return Ok(Spanned::new(
                Expr::AssignmentExpr {
                    target: Box::new(expr),
                    value: Box::new(value),
                },
                span,
            ));
        }
        Ok(expr)
    }

    fn parse_logical_or(&mut self) -> XResult<Spanned<Expr>> {
        let mut expr = self.parse_logical_and()?;
        while self.match_text("||") {
            let right = self.parse_logical_and()?;
            expr = binary("||", expr, right);
        }
        Ok(expr)
    }

    fn parse_logical_and(&mut self) -> XResult<Spanned<Expr>> {
        let mut expr = self.parse_equality()?;
        while self.match_text("&&") {
            let right = self.parse_equality()?;
            expr = binary("&&", expr, right);
        }
        Ok(expr)
    }

    fn parse_equality(&mut self) -> XResult<Spanned<Expr>> {
        let mut expr = self.parse_comparison()?;
        while self.check("==") || self.check("!=") {
            let op = self.bump().text;
            let right = self.parse_comparison()?;
            expr = binary(op, expr, right);
        }
        Ok(expr)
    }

    fn parse_comparison(&mut self) -> XResult<Spanned<Expr>> {
        let mut expr = self.parse_term()?;
        while matches!(self.peek().text.as_str(), ">" | ">=" | "<" | "<=") {
            let op = self.bump().text;
            let right = self.parse_term()?;
            expr = binary(op, expr, right);
        }
        Ok(expr)
    }

    fn parse_term(&mut self) -> XResult<Spanned<Expr>> {
        let mut expr = self.parse_factor()?;
        while self.check("+") || self.check("-") {
            let op = self.bump().text;
            let right = self.parse_factor()?;
            expr = binary(op, expr, right);
        }
        Ok(expr)
    }

    fn parse_factor(&mut self) -> XResult<Spanned<Expr>> {
        let mut expr = self.parse_unary()?;
        while self.check("*") || self.check("/") || self.check("%") {
            let op = self.bump().text;
            let right = self.parse_unary()?;
            expr = binary(op, expr, right);
        }
        Ok(expr)
    }

    fn parse_unary(&mut self) -> XResult<Spanned<Expr>> {
        if self.check("!") || self.check("-") {
            let start = self.cur_start();
            let op = self.bump().text;
            let value = self.parse_unary()?;
            let span = Span::new(self.file_id, start, value.span.end);
            return Ok(Spanned::new(
                Expr::UnaryExpr {
                    op,
                    value: Box::new(value),
                },
                span,
            ));
        }
        self.parse_postfix()
    }

    fn parse_postfix(&mut self) -> XResult<Spanned<Expr>> {
        let mut expr = self.parse_primary()?;
        loop {
            if self.match_text("(") {
                let start = expr.span.start;
                let mut args = Vec::new();
                if !self.check(")") {
                    args.push(self.parse_expr()?);
                    while self.match_text(",") {
                        args.push(self.parse_expr()?);
                    }
                }
                self.expect(")")?;
                let span = Span::new(self.file_id, start, self.last_end);
                expr = Spanned::new(
                    Expr::CallExpr {
                        callee: Box::new(expr),
                        args,
                    },
                    span,
                );
            } else if self.match_text(".") {
                let start = expr.span.start;
                let field = self.expect_ident()?.text;
                let span = Span::new(self.file_id, start, self.last_end);
                expr = Spanned::new(
                    Expr::FieldAccessExpr {
                        object: Box::new(expr),
                        field,
                    },
                    span,
                );
            } else {
                return Ok(expr);
            }
        }
    }

    fn parse_primary(&mut self) -> XResult<Spanned<Expr>> {
        let tok = self.peek().clone();
        let span = Span::new(self.file_id, tok.start, tok.end);
        match tok.kind {
            TokenKind::Int => {
                self.bump();
                Ok(Spanned::new(Expr::IntLiteral { value: tok.text }, span))
            }
            TokenKind::Float => {
                self.bump();
                Ok(Spanned::new(Expr::FloatLiteral { value: tok.text }, span))
            }
            TokenKind::String => {
                self.bump();
                Ok(Spanned::new(Expr::StringLiteral { value: tok.text }, span))
            }
            TokenKind::Ident => {
                self.bump();
                Ok(Spanned::new(Expr::Identifier { name: tok.text }, span))
            }
            TokenKind::Keyword if tok.text == "true" || tok.text == "false" => {
                self.bump();
                Ok(Spanned::new(
                    Expr::BoolLiteral {
                        value: tok.text == "true",
                    },
                    span,
                ))
            }
            _ if tok.text == "(" => {
                self.expect("(")?;
                let expr = self.parse_expr()?;
                self.expect(")")?;
                Ok(expr)
            }
            _ if tok.text == "[" => self.parse_array_literal(),
            _ => Err(XError::Parse(format!(
                "expected expression, got {:?} at {}:{}:{}",
                tok.text, self.file, tok.line, tok.col
            ))),
        }
    }

    fn parse_array_literal(&mut self) -> XResult<Spanned<Expr>> {
        let start = self.cur_start();
        self.expect("[")?;
        let mut elements = Vec::new();
        if !self.check("]") {
            elements.push(self.parse_expr()?);
            while self.match_text(",") {
                if self.check("]") {
                    break;
                }
                elements.push(self.parse_expr()?);
            }
        }
        self.expect("]")?;
        Ok(Spanned::new(
            Expr::ArrayLiteral { elements },
            Span::new(self.file_id, start, self.last_end),
        ))
    }
}

fn binary(op: impl Into<String>, left: Spanned<Expr>, right: Spanned<Expr>) -> Spanned<Expr> {
    let span = left.span.merge(right.span);
    Spanned::new(
        Expr::BinaryExpr {
            op: op.into(),
            left: Box::new(left),
            right: Box::new(right),
        },
        span,
    )
}

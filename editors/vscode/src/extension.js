// X Language VSCode extension entry point.
// Launches the xlang-lsp language server (stdio) and wires it to the editor
// via vscode-languageclient: live diagnostics, hover, go-to-definition,
// completion for .x files.

const vscode = require("vscode");
const { LanguageClient, TransportKind } = require("vscode-languageclient/node");

let client;

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
  // The server binary path: the `xlang.serverPath` setting, or `xlang-lsp`
  // on PATH by default. Build it from the compiler with `cargo build --release`.
  const config = vscode.workspace.getConfiguration("xlang");
  const serverPath = config.get("serverPath") || "xlang-lsp";

  const serverOptions = {
    run: { command: serverPath, transport: TransportKind.stdio },
    debug: { command: serverPath, transport: TransportKind.stdio },
  };

  const clientOptions = {
    documentSelector: [{ scheme: "file", language: "xlang" }],
    synchronize: {},
  };

  client = new LanguageClient(
    "xlang",
    "X Language Server",
    serverOptions,
    clientOptions
  );

  client.start();
  context.subscriptions.push(client);
}

function deactivate() {
  return client ? client.stop() : undefined;
}

module.exports = { activate, deactivate };

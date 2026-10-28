# nvim-config

Configuração do Neovim: IDE básica para **C** e **Assembly (NASM/GAS)**, com LSP (clangd), autocomplete, Treesitter, Telescope e explorer de arquivos. Plugins gerenciados com [lazy.nvim](https://github.com/folke/lazy.nvim).

## Requisitos

- **Neovim 0.11+** (usa a API nativa `vim.lsp.config`)
- `git`
- Uma [Nerd Font](https://www.nerdfonts.com/) no terminal (para os ícones)
- `clangd` (LSP de C/C++), `gcc`, `nasm` (para compilar com `<leader>b`)
- Opcional: `asm-lsp` (LSP de assembly), `ripgrep` (para o live grep do Telescope)

## Instalação

O Neovim lê a configuração de uma pasta fixa. Basta clonar este repositório nela.

### Linux / macOS

```sh
# Se já tiver uma config, faça backup
mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/jbug0x/nvim-config ~/.config/nvim
nvim
```

### Windows (PowerShell)

```powershell
# Se já tiver uma config, faça backup
Rename-Item "$env:LOCALAPPDATA\nvim" "nvim.bak"

git clone https://github.com/jbug0x/nvim-config "$env:LOCALAPPDATA\nvim"
nvim
```

Na primeira abertura o lazy.nvim instala os plugins sozinho. Depois reabra o Neovim.

### Instalando as dependências

| Sistema | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install neovim git gcc nasm clangd ripgrep` |
| Arch | `sudo pacman -S neovim git gcc nasm clang ripgrep` |
| Windows (winget/scoop) | `scoop install neovim git gcc nasm llvm ripgrep` |

Confira a versão com `nvim --version` (precisa ser 0.11 ou superior). Se a do seu gerenciador de pacotes for mais antiga, instale pelo [site oficial](https://github.com/neovim/neovim/releases).

## Atalhos

`<leader>` é a tecla **Espaço**.

### Edição

| Atalho | Modo | Ação |
|---|---|---|
| `Alt+j` / `Alt+k` | normal, insert, visual | Descer / subir a linha (ou a seleção) |
| `Alt+l` / `Alt+h` | normal, insert, visual | Indentar / desindentar |
| `Tab` / `Shift+Tab` | visual | Indentar / desindentar a seleção (mantém a seleção) |
| `>` / `<` | visual | Indentar / desindentar (mantém a seleção) |
| `Esc` | normal | Limpa o destaque da busca |

A indentação é de **4 espaços** em todos os tipos de arquivo, inclusive assembly.

> No Windows Terminal e na maioria dos terminais do Linux o `Alt` funciona direto. Se não responder, verifique se o terminal não captura `Alt+tecla` para outra função.

### Projeto e código

| Atalho | Ação |
|---|---|
| `<leader>ff` | Buscar arquivos |
| `<leader>fg` | Grep no projeto |
| `<leader>fb` | Buffers abertos |
| `<leader>e` | Explorer de arquivos |
| `<leader>b` | Compilar e rodar (C com gcc, NASM com nasm + gcc) |
| `gd` / `gr` / `K` | Definição / referências / documentação (LSP) |
| `<leader>rn` | Renomear |
| `<leader>ca` | Code action |
| `<leader>f` | Formatar |
| `[d` / `]d` | Diagnóstico anterior / próximo |
| `Esc Esc` | Sai do modo terminal |

## Observações

- O atalho `<leader>b` usa `nasm -f win64`, pensado para Windows. No Linux troque para `-f elf64` em `init.lua`.
- O shell do `:terminal` é o PowerShell só no Windows.
- `lazy-lock.json` fixa as versões dos plugins. Atualize com `:Lazy update`.

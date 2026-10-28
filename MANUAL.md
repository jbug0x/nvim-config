# Manual de uso

Guia rápido para usar esta configuração do Neovim no dia a dia. Para instalar, veja o [README](README.md).

`<leader>` é a tecla **Espaço**. `Alt+x` significa segurar Alt e apertar x.

## 1. Conceitos básicos do Neovim

O Neovim tem **modos**. O que cada tecla faz depende do modo em que você está.

| Modo | Como entrar | Para que serve |
|---|---|---|
| Normal | `Esc` | Navegar e dar comandos (modo padrão) |
| Insert | `i` (antes do cursor), `a` (depois), `o` (nova linha abaixo), `O` (acima) | Digitar texto |
| Visual | `v` (caracteres), `V` (linhas), `Ctrl+v` (bloco) | Selecionar texto |
| Comando | `:` | Salvar, sair, rodar comandos |

### Salvar e sair

| Comando | Ação |
|---|---|
| `:w` | Salva |
| `:q` | Sai |
| `:wq` ou `:x` | Salva e sai |
| `:q!` | Sai sem salvar |
| `:wa` / `:qa` | Salva tudo / sai de tudo |

### Navegação

| Tecla | Ação |
|---|---|
| `h` `j` `k` `l` | Esquerda, baixo, cima, direita |
| `w` / `b` | Próxima / anterior palavra |
| `0` / `$` | Início / fim da linha |
| `gg` / `G` | Início / fim do arquivo |
| `{número}G` | Vai para a linha do número |
| `Ctrl+d` / `Ctrl+u` | Meia página para baixo / cima |
| `/texto` | Busca no arquivo (`n` próxima, `N` anterior) |

A numeração é **relativa**: o número ao lado de cada linha mostra a distância até o cursor. Assim `5j` desce cinco linhas sem precisar contar.

### Editar

| Tecla | Ação |
|---|---|
| `x` | Apaga o caractere |
| `dd` | Apaga (recorta) a linha |
| `yy` | Copia a linha |
| `p` / `P` | Cola depois / antes |
| `u` / `Ctrl+r` | Desfaz / refaz |
| `cw` | Troca a palavra |
| `.` | Repete a última alteração |

O clipboard do sistema está integrado, então copiar no Neovim e colar em outro programa funciona (e o contrário também). O mouse também está ativo.

## 2. Mover linhas

| Atalho | Modo | Ação |
|---|---|---|
| `Alt+j` | normal, insert, visual | Desce a linha ou a seleção |
| `Alt+k` | normal, insert, visual | Sobe a linha ou a seleção |

Para mover várias linhas: `V`, selecione com `j`/`k`, depois `Alt+j` ou `Alt+k`. A seleção continua ativa, então você pode apertar várias vezes. O código é reindentado automaticamente ao chegar no novo lugar.

## 3. Indentação

A indentação é de **4 espaços** em qualquer tipo de arquivo, inclusive assembly. O `Tab` insere espaços, não o caractere de tab.

| Atalho | Modo | Ação |
|---|---|---|
| `Alt+l` | normal, insert, visual | Indenta |
| `Alt+h` | normal, insert, visual | Desindenta |
| `Tab` / `Shift+Tab` | visual | Indenta / desindenta a seleção |
| `>` / `<` | visual | Indenta / desindenta e mantém a seleção |
| `>>` / `<<` | normal | Indenta / desindenta a linha |
| `=` | normal/visual | Reindenta automaticamente (ex: `gg=G` no arquivo todo) |

Receita para indentar um bloco: `V`, selecione as linhas, aperte `Tab` quantas vezes precisar.

## 4. Arquivos e projeto

| Atalho | Ação |
|---|---|
| `<leader>e` | Abre/fecha o explorer de arquivos |
| `<leader>ff` | Busca arquivo pelo nome |
| `<leader>fg` | Busca texto em todos os arquivos |
| `<leader>fb` | Lista os buffers (arquivos) abertos |

**No explorer:** `Enter` abre, `a` cria arquivo (termine com `/` para criar pasta), `d` apaga, `r` renomeia, `x` recorta, `c` copia, `p` cola, `g?` mostra a ajuda.

**No Telescope:** digite para filtrar, `Ctrl+n`/`Ctrl+p` ou as setas movem, `Enter` abre, `Esc` fecha.

### Janelas

| Comando | Ação |
|---|---|
| `:vsplit` / `:split` | Divide na vertical / horizontal |
| `Ctrl+w` + `h/j/k/l` | Move entre janelas |
| `Ctrl+w` + `q` | Fecha a janela |

## 5. Código (LSP)

Funciona em arquivos C quando o `clangd` está instalado (e em assembly se o `asm-lsp` estiver).

| Atalho | Ação |
|---|---|
| `gd` | Vai para a definição |
| `gr` | Lista as referências |
| `K` | Mostra a documentação sob o cursor |
| `<leader>rn` | Renomeia o símbolo em todo o projeto |
| `<leader>ca` | Ações de código (correções sugeridas) |
| `<leader>f` | Formata o arquivo |
| `]d` / `[d` | Próximo / anterior diagnóstico (erro ou aviso) |

### Autocomplete

O menu aparece enquanto você digita.

| Tecla | Ação |
|---|---|
| `Tab` / `Shift+Tab` | Próxima / anterior sugestão |
| `Enter` | Confirma a sugestão selecionada |
| `Ctrl+Space` | Abre o menu manualmente |

### Comentar

O plugin Comment.nvim usa `gcc` para comentar/descomentar a linha e `gc` no modo visual para a seleção.

## 6. Compilar e rodar

`<leader>b` salva o arquivo, abre um terminal embaixo e compila/roda:

- **C:** `gcc -g -Wall -Wextra arquivo.c -o arquivo.exe` e executa.
- **NASM (`.asm`):** `nasm -f win64` seguido de `gcc` para linkar.

Para sair do modo terminal e voltar a navegar, aperte `Esc Esc`.

No Linux a saída do `nasm` deve ser `-f elf64`, e o executável não leva `.exe`. Ajuste isso no `init.lua`, no final do arquivo.

### Bootloader (16 bits)

Para um bootloader como `boot.S`, o `<leader>b` não serve, porque ele não gera um executável do sistema. Monte direto no terminal:

```sh
nasm -f bin boot.S -o boot.bin
qemu-system-i386 -drive format=raw,file=boot.bin
```

## 7. Plugins

| Comando | Ação |
|---|---|
| `:Lazy` | Abre o gerenciador de plugins |
| `:Lazy update` | Atualiza os plugins |
| `:Lazy sync` | Instala, atualiza e limpa |
| `:TSUpdate` | Atualiza os parsers do Treesitter |
| `:checkhealth` | Diagnostica problemas da instalação |

## 8. Problemas comuns

| Sintoma | O que fazer |
|---|---|
| Ícones quebrados (quadrados) | Instale uma Nerd Font e selecione no terminal |
| Sem autocomplete/LSP em C | Instale o `clangd` e confira com `:checkhealth vim.lsp` |
| `Alt+tecla` não responde | O terminal está capturando; verifique as configurações de atalho dele |
| Indentação de 8 no assembly | Rode `:verbose set tabstop?` para ver quem definiu o valor |
| Erro ao abrir pela primeira vez | Confira se o Neovim é 0.11+ (`nvim --version`) e se o `git` está instalado |
| Live grep não funciona | Instale o `ripgrep` |

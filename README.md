# Slideshow de wallpapers para GNOME

Este diretório contém imagens e um script para criar e ativar um slideshow de
wallpapers no GNOME. As imagens são exibidas em ordem alfabética, permanecem
paradas por 57 segundos e fazem uma transição gradual de 3 segundos para a
próxima imagem.

## Requisitos

- GNOME com `gsettings` disponível;
- Bash;
- Python 3;
- Pelo menos duas imagens nesta pasta.

O script reconhece os formatos `.jpg`, `.jpeg`, `.png`, `.webp` e `.jxl`,
sem distinção entre letras maiúsculas e minúsculas.

## Uso

A partir deste diretório, execute:

```bash
./gerar-slideshow.sh
```

Se o arquivo não tiver permissão de execução, use:

```bash
bash gerar-slideshow.sh
```

O script:

1. Localiza as imagens da pasta e ordena seus nomes alfabeticamente;
2. Gera ou atualiza [`slideshow.xml`](./slideshow.xml);
3. Configura o arquivo como wallpaper claro e escuro do GNOME;
4. Define o modo de ajuste como `zoom`.

O XML gerado usa caminhos absolutos. Portanto, execute o script novamente se
este diretório for movido ou se as imagens forem reorganizadas.

## Personalização

Os tempos podem ser alterados no início de
[`gerar-slideshow.sh`](./gerar-slideshow.sh):

```bash
STATIC=57   # segundos com a imagem parada
FADE=3      # segundos da transição
```

O tempo total de cada imagem é `STATIC + FADE`. Com os valores padrão, cada
imagem ocupa 60 segundos do ciclo. A ordem pode ser controlada renomeando os
arquivos, por exemplo:

```text
wallpaper-01.jpg
wallpaper-02.jpg
wallpaper-03.jpg
```

Depois de qualquer alteração, execute o script novamente para regenerar o XML
e aplicar a configuração.

## Imagens incluídas

O conjunto atual contém 24 imagens, de `wallpaper-01.jpg` a
`wallpaper-24.jpg`. A última imagem faz transição de volta para a primeira,
formando um ciclo contínuo.

## Solução de problemas

### O slideshow não muda

Verifique se o ambiente está usando o GNOME e se `gsettings` está disponível:

```bash
command -v gsettings
```

Depois, execute o script novamente. Ele força uma recarga quando o GNOME já
está apontando para o mesmo arquivo XML.

### O script informa que faltam imagens

É necessário ter pelo menos duas imagens com uma das extensões suportadas na
mesma pasta do script.

### Uma imagem nova não aparece

Confirme a extensão e execute novamente:

```bash
./gerar-slideshow.sh
```

### Restaurar um wallpaper estático

Nas configurações do GNOME, abra **Aparência** e selecione outra imagem.
Também é possível usar `gsettings`, substituindo o caminho pelo arquivo
desejado:

```bash
gsettings set org.gnome.desktop.background picture-uri \
  "file:///caminho/para/imagem.jpg"
```

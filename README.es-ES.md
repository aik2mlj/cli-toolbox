

# Caja de Herramientas de Línea de Comandos de Lejun

Una colección curada de herramientas modernas de línea de comandos y configuraciones de shell para un desarrollo productivo basado en terminal. Funciona en Linux, macOS o WSL en Windows, ya sea que estés configurando un **entorno de desarrollo local** o un **servidor remoto sin acceso root**.

La caja de herramientas incluye un conjunto de herramientas que considero esenciales para el desarrollo diario (ver [Herramientas CLI Incluidas](#cli-tools-included) más abajo), junto con sus configuraciones. Para recomendaciones de configuración de escritorio local (Linux), consulta mi [repositorio de dotfiles](https://github.com/aik2mlj/chezmoi).

## Instalación

El script [install.sh](./install.sh) se encarga de todo. Realiza una copia de seguridad de cualquier configuración existente antes de instalar.

### Clonar el Repositorio

```shell
git clone https://github.com/aik2mlj/cli-toolbox.git && cd cli-toolbox
```

### Instalación a Nivel de Sistema

Si estás en una máquina con acceso sudo y los paquetes de tu distribución están razonablemente actualizados (Arch Linux, Fedora, macOS), usa tu administrador de paquetes (`dnf`, `pacman`, `brew`, etc.) para los binarios y aplica solo las configuraciones:

```shell
# for macOS with Homebrew
brew install fish bat btop difftastic dust eza fd sevenzip fzf lazygit mcat fresh-editor ripgrep starship yazi zoxide ffmpeg-full jq poppler resvg imagemagick-full mediainfo font-symbols-only-nerd-font
brew link ffmpeg-full imagemagick-full -f --overwrite

# for Arch Linux
paru -S --needed fish bat btop difftastic dust eza fd 7zip fzf lazygit mcat-bin fresh-editor-bin ripgrep starship yazi zoxide ffmpeg jq poppler resvg imagemagick mediainfo

# apply the configs
./install.sh --config-only                        # install essential configs only
./install.sh --config-only --overwrite            # install essential configs, overwrite existing
```

Recuerda actualizar los binarios de vez en cuando con tu administrador de paquetes.

### Instalación de Usuario (Sin Root)

Elige esta opción si no tienes acceso root a la máquina, por ejemplo, un servidor restringido. O si usas distribuciones de Linux con paquetes desactualizados en el repositorio oficial, como Ubuntu o Debian (ya que esta caja de herramientas solo se ha probado con las versiones más recientes). Esto descarga todos los binarios a `~/.local/bin/` (sin necesidad de root) e instala las configuraciones:

```shell
./install.sh                # install binaries + essential configs (with backup)
./install.sh --overwrite    # same, without backing up existing config files
```

Para instalar solo los binarios o actualizarlos (reinstalarlos):

```shell
# these are equivalent
./install.sh --binary-only
./install.sh --upgrade
```

También puedes instalar `ffmpeg` (desde el binario nightly de [este repositorio](https://github.com/BtbN/FFmpeg-Builds)) usando este script, si aún no lo tienes. `ffmpeg` es una herramienta potente para el procesamiento de audio y video. Puede incluirse para la vista previa de miniaturas de video en `yazi`.

```shell
./install.sh --ffmpeg
```

### Instalación Personalizada

Si solo quieres instalar unas pocas herramientas que faltan en tu repositorio, o algunas herramientas adicionales que no están incluidas aquí, puedes usar [gah](https://github.com/get-gah/gah) para instalarlas manualmente:

```shell
./install.sh --gah                                # this installs gah, the binary installer, to ~/.local/bin/
gah install Skardyy/mcat                          # say, mcat is not in your repo
gah install jesseduffield/lazydocker              # install lazydocker, which is not included in the toolbox
```

Ejecuta `gah --help` para verificar el uso. Consulta la documentación de [gah](https://github.com/get-gah/gah) para más detalles.

Y por supuesto, puedes copiar manualmente archivos de configuración individuales de este repositorio a sus respectivas ubicaciones en tu directorio de inicio.

### Emulador de Terminal

Usa un emulador de terminal moderno que renderice bien imágenes y [Nerd Font](https://www.nerdfonts.com/). Recomiendo [Ghostty](https://ghostty.org/), que funciona directamente sin configuración, o [Kitty](https://sw.kovidgoyal.net/kitty/) si necesitas más funciones y una configuración extensiva (lo que yo uso).

- Puede resultarte muy útil conocer la gestión de pestañas / ventanas de tu emulador y sus diversos atajos de teclado. Para Ghostty, echa un vistazo a esta [hoja de trucos](https://ricoberger.de/cheat-sheets/ghostty/).

Ahora, simplemente abre el emulador y disfruta de tu terminal embellecida y súper potenciada.

### Post-Instalación

- Es posible que quieras configurar `fish` como shell predeterminado.
  - Si es una configuración local, cambia el shell de inicio de sesión con `chsh -s $(which fish)`. Si falla, añade `fish` a `/etc/shells` primero con `sudo sh -c 'echo $(which fish) >> /etc/shells'`.
    - También podrías simplemente necesitar establecer `fish` como comando a ejecutar al inicio en la configuración de tu emulador de terminal, sin cambiar el shell de inicio de sesión. Para usuarios de Ghostty, esto ya está cubierto en esta configuración.
  - Si se trata de un servidor remoto sin `fish` instalado a nivel de sistema, consulta esta [guía de configuración](https://wiki.archlinux.org/title/Fish#Setting_fish_as_interactive_shell_only).
    - Si siempre inicias `tmux`, ya estás cubierto: el shell predeterminado en `tmux` se ha establecido en `fish`.

- Si quieres instalar binarios adicionales en `~/.local/bin/`, consulta [Instalación Personalizada](#customized-installation)

- Revisa [Opcional](#optional) para herramientas y configuraciones adicionales que puedan interesarte.

## Herramientas CLI Incluidas

Aquí tienes un breve resumen. Recomiendo navegar por la guía de inicio rápido de cada herramienta siguiendo el enlace, pero solo cuando lo necesites. La mayoría son autoexplicativas e intuitivas para empezar.

- [fish](https://fishshell.com/) - Un shell de línea de comandos inteligente y amigable. Pestañas más inteligentes, autocompletado y resaltado de sintaxis integrados.
  - Lectura recomendada: El [tutorial](https://fishshell.com/docs/current/tutorial.html) y la [guía interactiva](https://fishshell.com/docs/current/interactive.html) del shell fish.
- [bat](https://github.com/sharkdp/bat) - Un clon de `cat` con resaltado de sintaxis e integración con Git. Usado por `fzf.fish` para previsualizar archivos en la búsqueda de directorios.
- [btop](https://github.com/aristocratos/btop) - Una herramienta de monitoreo de recursos del sistema. Alternativa a `htop`.
- [difftastic](https://difftastic.wilfred.me.uk/): Una herramienta de diff estructural que entiende la sintaxis.
  - Proporciona una salida de diff más intuitiva y legible en comparación con `diff` o `git diff`, especialmente para cambios de código.
- [dust](https://github.com/bootandy/dust) - Una versión más intuitiva de `du` escrita en Rust, útil para inspeccionar el uso del disco.
- [eza](https://github.com/eza-community/eza) - Una alternativa moderna a `ls` con colores e iconos.
- [fd](https://github.com/sharkdp/fd) - Una alternativa simple, rápida y amigable a `find`.
- [7-zip](https://www.7-zip.org/) - Un archivador de archivos con una alta relación de compresión.
- [fzf](https://github.com/junegunn/fzf) - Un localizador difuso de línea de comandos increíblemente rápido.
- [lazygit](https://github.com/jesseduffield/lazygit) - Una interfaz de terminal intuitiva para `git`.
  - Con solo unos pocos golpes de teclado para realizar pull, fetch, push o commit, la encontré mucho más fácil de usar que los comandos de git y todas las herramientas GUI de git. También incluye características avanzadas de cherry-picking, rebasing y gestión de stashes a mano.
- [mcat](https://github.com/Skardyy/mcat) - Un visor versátil que renderiza muchos tipos de archivos (markdown, imagen/video, pdf, docx, pptx, xlsx, html, etc.) directamente en la terminal. Muy útil para la vista previa de `yazi`.
- [fresh](https://getfresh.dev/) - Un editor de texto e IDE moderno para terminal con curva de aprendizaje cero. Una experiencia similar a VSCode en la terminal.
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Una alternativa moderna (y mucho más rápida) a `grep`. Busca recursivamente en directorios patrones regex.
- [starship](https://starship.rs/) - Un prompt minimalista, increíblemente rápido e infinitamente personalizable para cualquier shell.
- [yazi](https://yazi-rs.github.io/) - Un gestor de archivos de terminal increíblemente rápido escrito en Rust.
  - Imprescindible para navegar por la terminal. Deja de usar `cd` y `ls` para navegar por archivos. Tiene búsqueda difusa integrada, resaltado de código, descompresión y vista previa de imágenes. Consulta la [documentación de inicio rápido](https://yazi-rs.github.io/docs/quick-start/) y esta [hoja de trucos](https://ricoberger.de/cheat-sheets/yazi/).
- [zoxide](https://github.com/ajeetdsouza/zoxide) - Un comando `cd` más inteligente que recuerda tus directorios más usados y te permite saltar a ellos rápidamente.

Algunas herramientas adicionales ([jq](https://jqlang.org/), [poppler](https://poppler.freedesktop.org/), [ffmpeg](https://www.ffmpeg.org/), [resvg](https://github.com/linebender/resvg), [ImageMagick](https://imagemagick.org/), [mediainfo](https://mediaarea.net/en/MediaInfo)) son necesarias como dependencias para la función completa de vista previa de `yazi`. Consulta la [documentación de yazi](https://yazi-rs.github.io/docs/installation/) para saber por qué son necesarias.

- Si usas la instalación sin root, `jq`, `resvg`, `imagemagick` (`magick`) y `mediainfo` se instalan automáticamente. `ffmpeg` está disponible por separado (consulta [Instalación de Usuario](#user-scoped-rootless-installation)) debido a su gran tamaño de binario; `poppler` lamentablemente no se puede instalar fácilmente como binario estático, puedes instalarlo sin root desde `conda-forge`.

## Detalles de Configuración

- `fish` - Uso `fish` como mi shell. La configuración incluye algunas funciones, abreviaturas y alias útiles. Consulta el archivo de configuración principal en [`~/.config/fish/config.fish`](home/.config/fish/config.fish) para más detalles. Algunas notas:
  - `z` es un alias para `zoxide`. Prueba simplemente `z <nombre parcial de un directorio que hayas visitado>` para saltar a ese directorio. ¡Adiós a los tediosos `cd`!
  - El prompt predeterminado está configurado para usar `starship`, que proporciona un prompt agradable e informativo.
  - El editor predeterminado está configurado en `fresh`.
  - `ctrl + o` abre el gestor de archivos `yazi` y cambiará el directorio de trabajo actual al salir (el [envoltorio](https://yazi-rs.github.io/docs/quick-start#shell-wrapper) está configurado en [`functions/yazi-cd.fish`](home/.config/fish/functions/yazi-cd.fish)).
  - Los atajos del localizador difuso provienen de [fzf.fish](https://github.com/PatrickF1/fzf.fish).
    - `ctrl + r` para buscar en tu historial de comandos.
    - `ctrl + f` para buscar archivos bajo el directorio actual.
  - `ls`, `ll`, etc. están mapeados a `eza`, que muestra colores e iconos.
  - Para acelerar el inicio del shell, `conda init` se carga de forma perezosa solo después de ejecutar el comando `conda` por primera vez.

- `yazi` - Los archivos de configuración están en [`~/.config/yazi/`](home/.config/yazi/). Básicamente instalé algunos plugins para mejorar la funcionalidad y la apariencia.
  - `shift + j/k` para navegar 5 veces más rápido en la lista de archivos. `opt/alt + j/k` para desplazarse 5 unidades arriba/abajo en la vista previa (por ejemplo, ver la siguiente página de un archivo de texto previsualizado, o el siguiente fotograma de un video).
  - [smart-enter.yazi](https://github.com/yazi-rs/plugins/tree/main/smart-enter.yazi) para abrir archivos o entrar a directorios con una tecla (`l` o flecha derecha).
  - [piper.yazi](https://github.com/yazi-rs/plugins/tree/main/piper.yazi) para tuberizar cualquier comando de shell como previsualizador.
  - [full-border.yazi](https://github.com/yazi-rs/plugins/tree/main/full-border.yazi) para que se vea más elegante.
  - [git.yazi](https://github.com/yazi-rs/plugins/tree/main/git.yazi) para mostrar el estado de los cambios de git en la lista de archivos.
  - [compress.yazi](https://github.com/KKV9/compress.yazi) para comprimir archivos seleccionados en un archivo (atajo: `ca`).
  - [mediainfo.yazi](https://github.com/boydaihungst/mediainfo.yazi) para mostrar miniaturas usando `ffmpeg` y metadatos de medios usando `mediainfo` (alternar mostrar metadatos: `<f9>`).

- `lazygit` - El archivo de configuración está en [`~/.config/lazygit/config.yml`](home/.config/lazygit/config.yml). La herramienta de diff predeterminada está configurada en `difftastic`, que proporciona una salida de diff más intuitiva.

- `ghostty` - El shell predeterminado está configurado en `fish` en [`~/.config/ghostty/config.ghostty`](home/.config/ghostty/config.ghostty).

- `tmux` - Por lo general, me baso en la gestión de pestañas / ventanas de mi emulador de terminal para la multitarea en una máquina local. Pero al trabajar en servidores remotos, `tmux` es esencial para mantener las sesiones activas cuando te desconectas. Esta configuración usa [oh my tmux](https://github.com/gpakosz/.tmux). Incluye una barra de estado con información del sistema, estado de la batería y más. Algunas notas:
  - Consulta el [repositorio original](https://github.com/gpakosz/.tmux) para atajos y usos inteligentes.
    - Agrega un prefijo más manejable `ctrl + a` (comparado con el predeterminado `ctrl + b`).
    - Incluye algunos atajos útiles, como `<prefix> + h/j/k/l` para cambiar entre paneles, y `<prefix> Ctrl + h/j/k/l` para cambiar entre ventanas.
  - Mis ajustes personales están en la sección de _personalizaciones de usuario_ en el archivo [`~/.tmux.conf.local`](home/.tmux.conf.local).
    - El shell predeterminado en `tmux` está configurado en `fish`. Puedes cambiarlo a tu shell preferido modificando la línea `default-shell`.
    - Se incluye una corrección que habilita el reenvío del agente ssh para que funcione después de volver a conectarse a `tmux`. Consulta [este blog](https://werat.dev/blog/happy-ssh-agent-forwarding/) para más detalles.

## Opcional

- Si eres Lejun o quieres usar cada configuración de este repositorio, agrega la bandera `--all` a `./install.sh`. Revisa todas las configuraciones en el repositorio antes de aplicarlas.

- Puedes encontrar fuentes geniales que soportan iconos de línea de comandos en [Nerd Fonts](https://www.nerdfonts.com/font-downloads). Elige una que te guste, descárgala e instálala, y configúrala como fuente en tu emulador de terminal. Esto podría ser necesario si notas que algunos iconos faltan (se muestran como cuadrados vacíos).

- [Neovim](https://neovim.io/): Si quieres ser hardcore usando Neovim como tu editor principal en la terminal, recomiendo [LazyVim](https://www.lazyvim.org/) como configuración base. Ahorra un montón de tiempo proporcionando una experiencia de IDE completa directamente. Pero prepárate para dedicar bastante tiempo a pasar por todas las herramientas y configurar tu propia versión. Este repositorio contiene una configuración mínima de Lazyvim ajustada a mi gusto. Puedes copiar la configuración de Neovim en este repositorio con

  ```shell
  ./install.sh --nvim               # install neovim binary (for rootless)
  ./install.sh --nvim-config        # apply neovim config
  ```

  Y podrías querer cambiar `EDITOR` a `nvim` en `~/.config/fish/config.fish` o donde tengas configurado el editor.

- [uv](https://docs.astral.sh/uv/): Un gestor de paquetes y proyectos de Python extremadamente rápido, escrito en Rust. Altamente recomendado sobre `conda` o `venv` para la mayoría de casos de gestión de entornos Python: una sola herramienta que reemplaza `pip`, `pip-tools`, `pipx`, `poetry`, `pyenv`, `twine`, `virtualenv` y más, y es de 10 a 100 veces más rápido que `pip`. Instala con `gah install astral-sh/uv` o tu administrador de paquetes.

- [Zellij](https://zellij.dev/): ¿Cansado de recordar todos los atajos de `tmux`? `zellij` es una alternativa moderna en Rust a `tmux` con una interfaz más intuitiva, atajos y muchas características excelentes.

- [Lazydocker](https://github.com/jesseduffield/lazydocker): Similar a `lazygit`, pero para Docker. Proporciona una interfaz de terminal para gestionar contenedores, imágenes y volúmenes de Docker.

- [nvtop](https://github.com/Syllo/nvtop) o [nvitop](https://github.com/XuehaiPan/nvitop) para monitoreo de GPU: Si trabajas con GPUs, estas herramientas proporcionan una interfaz de terminal agradable para monitorear el uso de GPU, memoria y procesos.

- ¿Quieres gestionar tus archivos de configuración con elegancia? Consulta [dotfiles](https://dotfiles.github.io/) para tutoriales y herramientas. Mi elección es [chezmoi](https://www.chezmoi.io/).

- Para recomendaciones de configuración de escritorio local (Linux), consulta mi [repositorio de dotfiles](https://github.com/aik2mlj/chezmoi).

## Detalles Técnicos

Si eliges usar este script para instalar los binarios (en lugar de usar tu administrador de paquetes si estás en una máquina local), se descargan en el momento de la instalación desde sus lanzamientos oficiales de GitHub usando [gah](https://github.com/get-gah/gah) (vendido y modificado en [`tools/gah`](tools/gah)). Detectará automáticamente la arquitectura de tu sistema y descargará los binarios apropiados. Todas las herramientas, incluido `jq` (requerido por gah) si no está presente, se instalan en `~/.local/bin/` sin root.

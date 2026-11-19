# Limits

These are places where scpp or the GTK wrapper cannot do what cedit
does. The editor still does the closest real job, and the unit tests
cover that job.

cedit stores projects under `.cwhip/`. This editor uses `.side/` so
it does not pretend to be a cedit checkout. Global settings are
`ide.toml`, not the compiler `config.ini`, and not cedit's
`settings.toml`. The legacy shortcut file is `ide-shortcuts.conf`.

The wrapper has no GtkSourceView and no language-spec directory. The
scanner highlights scpp, C, C++, cw, Python, shell, and toml. Other
files, including Markdown, stay plain. Tags are foreground colors
only. There is no gutter, line-number bar, whitespace glyph, newline
mark, indent guide, right-margin line, or current-line background.
Those flags are stored. The status line shows the line and column
from the editor buffer. The view's cursor report is a character
offset. The buffer's column is a byte offset, so a multibyte
character and the status column can disagree.

There is no accelerator API and no key-press signal on the text
view. Shortcuts are stored, checked, and shown in settings. Menus run
the commands. The text view keeps GTK's own selection, clipboard, and
navigation keys, which are separate from the editor clipboard and the
editor undo stack. A shortcut is recorded by typing the GTK trigger
text. Multi-line typing is Insert at Column and Delete at Column.
Those commands use the editor clipboard. They are not live keystrokes.

FileDialog picks one path. It has no folder mode and no multi-select.
Open Folder, New Project, Open Project, and Save Project As use a
dialog with a path entry. Recent files are rows in the File menu,
not a nested submenu. Tab titles are rebuilt when the document list
changes. There is no per-tab close icon. File, Close closes the
active document. There is no context menu. Reload is in the File
menu. Refresh and Show Hidden are a button and a checkbox. The
sidebar is a column list of the expanded tree, with an indent and a
one-letter kind, not a tree widget and not icons.

The wrapper cannot set the font family, the font size, wrapping, or
the right margin. Those values are stored. The editor view is always
monospace. Save on tab change is wired to the notebook. Save on
window-focus loss is stored and `save_on_window_loss` performs it,
but the wrapper has no focus signal, so the window does not call it.
The menu row is the first child of the window because the wrapper has
no title-bar setter.

Diagnostics are a status count, a foreground tag, and one tooltip.
There is no per-line hover, background tint, or gutter mark. The
disk and diagnostic poll is a thread that sleeps three seconds and
posts back to the GUI thread. Case-insensitive search folds ASCII
only. A URI that contains `://` is rejected as not a local path.
Settings and project saves are synchronous renames with an
expected-content check, not GIO etags. A second process with the same
application id is delivered to the first by GTK and does not receive
the new file list.

The editor does not add build commands, Git, project trust, a
configurable toolbar, or dynamic plugins. cedit does not provide
those either. The about window names version 0.0.1 and the smallcpp
repositories. This repository ships no license file, so the about
text does not claim one.

vim9script

# Author: Owajigbanam Ogbuluijah
# Github: http://github.com/igbanam
# Original: http://github.com/igbanam/vim-notify
# LICENSE: MIT

# This is an opinionated way to show notifications in Vim.
#
# It's originally built using vim9script (i.e. for Vim 8.2+)

# Configuration ---------------------------------------------------------- {{{
g:vim_notify__delay = 5            # Amount of seconds a notification shows
g:vim_notify__width = 40           # How wide a notification should span
g:vim_notify__place = 'botright'   # Notification position on the screen
g:vim_notify__title = 'Vim Notify' # Notifications are better with a title
g:vim_notify__stack = v:true       # Should I stack notifications?
# ------------------------------------------------------------------------ }}}

# Facade ----------------------------------------------------------------- {{{
def g:NotifyInfo(message: string): void
  var opts: dict<any> = {
    highlight: 'Normal',
    title: ' ' .. g:vim_notify__title .. ' ',
  }
  Notify(message, opts)
enddef

def g:NotifySuccess(message: string): void
  var opts: dict<any> = {
    highlight: 'String',
    title: ' ✓ ' .. g:vim_notify__title .. ' ',
  }
  Notify(message, opts)
enddef

def g:NotifyWarning(message: string): void
  var opts: dict<any> = {
    highlight: 'WarningMsg',
    title: ' ⚠ ' .. g:vim_notify__title .. ' ',
  }
  Notify(message, opts)
enddef

def g:NotifyError(message: string): void
  var opts: dict<any> = {
    highlight: 'Exception',
    title: ' x ' .. g:vim_notify__title .. ' ',
  }
  Notify(message, opts)
enddef
# ------------------------------------------------------------------------ }}}

# Internals -------------------------------------------------------------- {{{
var active_notifications: list<number>

var default_opts = {
  zindex: 200,
  tabpage: -1,
  pos: 'topright',
  border: [],
  padding: [0, 1, 0, 1],
  time: g:vim_notify__delay * 1000,
  maxwidth: g:vim_notify__width,
  minwidth: g:vim_notify__width,
  borderchars: ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
  callback: 'HandleCloseNotification'
}

def Notify(message: string, opts: dict<any>): void
  var notification_window: number
  if g:vim_notify__stack
  else
    if active_notifications->len() > 0
      notification_window = active_notifications->remove(0)
      popup_hide(notification_window)
    endif
  endif
  notification_window = popup_create(
    PrepareMessage(message),
    extend(PrepareOptions(), opts)
  )
  active_notifications->add(notification_window)
enddef

def HandleCloseNotification(id: number, result: any)
  var window_index = active_notifications->index(id)
  active_notifications->remove(window_index)
enddef
# ------------------------------------------------------------------------ }}}

# Utilities -------------------------------------------------------------- {{{
def PlaceToPosition(place: string): dict<any>
  var the_line: number = GetNewLine(place)

  if place == 'topright'
    return { pos: place, line: the_line, col: &columns - 1 }
  elseif place == 'topleft'
    return { pos: place, line: the_line, col: 1 }
  elseif place == 'botright'
    return { pos: place, line: the_line, col: &columns - 1 }
  elseif place == 'botleft'
    return { pos: place, line: the_line, col: &columns - 1 }
  endif

  echoerr "I don't know how to translate <" .. place .. ">"
  throw 'VimNotify::UnknownPlace'
  return {}
enddef

def PrepareOptions(): dict<any>
  return extend(default_opts, PlaceToPosition(g:vim_notify__place))
enddef

def PrepareMessage(message: string): list<string>
  var result: list<string> = []
  var current_length: number = 0
  var current_line: list<string> = []

  for word in split(message)
    if current_length + len(word) >= g:vim_notify__width
      add(result, join(current_line))
      current_line = []
      current_length = 0
    endif

    add(current_line, word)
    current_length = current_length + len(word) + 1  # for <space>
  endfor

  add(result, join(current_line))

  return result
enddef

def GetNewLine(place: string): number
  if active_notifications->empty()
    if place =~ '^top'
      return 2
    elseif place =~ '^bot'
      return &lines - 2
    endif
  endif

  var new_line = 0
  if place =~ '^top'
    new_line = active_notifications->deepcopy()->map((_, w) => {
      var the_pos = popup_getpos(w)
      return the_pos['line'] + the_pos['height']
    })->max()
  elseif place =~ '^bot'
    new_line = active_notifications->deepcopy()->map((_, w) => {
      var the_pos = popup_getpos(w)
      return the_pos['line'] - 1
    })->min()
  else
    echoerr "Place should be one of 'topright', 'topleft', 'botright', 'botleft'"
    throw 'VimNotify::UnknownPlace'
  endif
  return new_line
enddef
# ------------------------------------------------------------------------ }}}
defcompile

# vim-notify

`vim-notify` is a library-type plugin which allows plugin developers show notifications with a nice UI in Vim. `vim-notify` is intentionally opinionated and simple. You can use it as a library to build your own plugin, or you can use it as a stand-alone plugin:

```vim
" Vim packager
call packager#add('igbanam/vim-notify')
" Vim Plug
Plug 'igbanam/vim-notify'
```

## Configuration

| Option                | Definition                             |
| ---                   | ---                                    |
| `g:vim_notify__delay` | Amount of seconds a notification shows |
| `g:vim_notify__width` | How wide a notification should span    |
| `g:vim_notify__place` | Notification position on the screen    |
| `g:vim_notify__title` | Notifications are better with a title  |
| `g:vim_notify__stack` | Notifications should form a list       |

## Example usage

### NotifyInfo(msg: String)
```vim
call NotifyInfo('Long notifications can span multiple lines.')
```
<img width="643" alt="Screenshot 2022-10-08 at 02 08 35" src="https://user-images.githubusercontent.com/390059/194682938-e6e8fc3f-3e83-4468-87a6-23889f4a074a.png">

### NotifyWarning(msg: String)
```vim
call NotifyWarning('Something went wrong. Please check your logs')
```
<img width="642" alt="Screenshot 2022-10-08 at 02 10 42" src="https://user-images.githubusercontent.com/390059/194682941-bd4ab00d-e7b1-413c-beac-e90a67eefc40.png">

### NotifySuccess(msg: String)
```vim
call NotifyWarning('Something went wrong. Please check your logs')
```
<img width="641" alt="Screenshot 2022-10-08 at 02 13 03" src="https://user-images.githubusercontent.com/390059/194682945-1c083aea-ec3a-492b-8e4c-f388379f4ad8.png">

### NotifyError(msg: String)
```vim
call NotifyError('Something went wrong. Please check your logs')
```
<img width="644" alt="Screenshot 2022-10-08 at 02 12 02" src="https://user-images.githubusercontent.com/390059/194682944-f9b5f5b2-d9da-4f91-a028-4b42cc66295f.png">

## Roadmap

- [x] Stack Notifications
- [ ] Respect newline characters in notification
- [ ] Add support for more notification positions on screen
  - [ ] North Central
  - [ ] South Central
- [ ] (Optional) Standardize Colours

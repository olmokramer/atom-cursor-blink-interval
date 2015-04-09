# cursor-blink-interval

Simple package that controls the cursor blinking interval. Set to `0` to disable cursor blinking (well... it will blink once every ~50 days).
Doesn't work in `mini` editors, except for disabling the blinking.

Try my other package, [block-cursor](https://atom.io/packages/block-cursor), for more cursor customization

## scoped config support

You can now define different intervals for different scopes:

```cson
# ~/.atom/config.cson
'*':
  'cursor-blink-interval':
    cursorBlinkInterval: 1000 # 1000ms global value
'.coffee.source':
  'cursor-blink-interval':
    cursorBlinkInterval: 2000 # 2000ms in coffee-script scope
```

## copyright

Copyright 2015 Olmo Kramer under MIT license.
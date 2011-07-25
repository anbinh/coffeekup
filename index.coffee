template = ->
  doctype 5
  html ->
    head ->
      meta charset: 'utf-8'
      title 'CoffeeKup'
      link id: 'bespin_base', href: 'bespin'
      script src: 'jquery-1.6.2.min.js'
      script src: 'bespin/BespinEmbedded.js'
      script src: 'coffee-script.js'
      script src: 'coffeekup.js'
      script @js
      style @css
      script "var _gaq=[['_setAccount','UA-4475762-17'],['_trackPageview']];(function(d,t){
        var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
        g.async=1;g.src='//www.google-analytics.com/ga.js';s.parentNode.insertBefore(g,s)
        })(document,'script')</script>"
    body ->
      div id: 'container', ->
        h1 id: 'logo', ->
          span class: 'delim', -> h('<')
          span class: 'u', -> 'Ũ' #'ỦŰ'
          span class: 'wing', -> 'ↄ' # ƿↄ
          span class: 'delim', -> h('/>')
        h2 id: 'desc', ->
          text 'CoffeeKup is <strong>markup</strong> as <strong>CoffeeScript</strong>. '
          a id: 'info', href: 'http://github.com/mauricemach/coffeekup', -> 'More Info'

        section id: 'options', ->
          section ->
            label for: 'opts', -> 'Params: '
            input id: 'opts', type: 'text'
          section ->
            input id: 'format', type: 'checkbox', checked: yes
            label for: 'format', -> 'Format Output'

        p id: 'errors'
        textarea id: 'in', -> @sample
        textarea id: 'out'

      a href: 'http://github.com/mauricemach/coffeekup', ->
        img style: 'position: absolute; top: 0; right: 0; border: 0;', src: '/forkme_right_white_ffffff.png', alt: 'Fork me on GitHub'

@js = ->
  editor = null
  out = null

  window.onBespinLoad = ->
    compile = ->
      try
        options = options: {format: $('#format').is(':checked'), autoescape: yes}
        eval 'opts = ' + $('#opts').val()
        out.value = CoffeeKup.render editor.value, opts, options
        out.setLineNumber 1
        $('#errors').hide()
      catch err
        $('#errors').show().html err.message

    $('#opts').bind 'keyup', -> compile()
    $('#format').bind 'click', -> compile()

    $('#opts').attr 'value', "{title: 'Foo', path: '/zig', user: {}, max: 12, locals: {shoutify: function(s){return s.toUpperCase() + \'!\';}}}"
    bespin.useBespin('out', stealFocus: yes, syntax: 'html', settings: {tabstop: 2}).then (env) ->
      out = env.editor
    bespin.useBespin('in', stealFocus: yes, syntax: 'coffee', settings: {tabstop: 2, fontface: 'Monaco, DejaVu Sans Mono, monospace'}, fontsize: '8px').then (env) ->
      editor = env.editor
      editor.textChanged.add (old_range, new_range, new_text) -> compile()
      compile()

@js = "(#{@js}).call(this);"

@css = """
  html, body {margin: 0; padding: 0}
  body {
    background: #473e39;
    color: #ccc; 
    font-family: Ubuntu, Lucida Grande, Gill Sans, Segoe UI, Lucida Sans Unicode, Tahoma, sans-serif;
  }
  #container {padding-top: 140px; width: 1120px; margin: auto; position: relative; text-align: right}
  a {color: #09f}
  a:hover {color: #0cf}
  #logo {
    position: absolute; top: 15px; right: 20px;
    margin: 0;
    font-size: 90px;
    font-weight: normal; display: inline;
    font-family: Gill Sans, DejaVu Sans, Segoe UI, Calibri, Lucida Sans Unicode, sans-serif;
  }
  #logo .u {color: #fff; text-decoration: none}
  #logo .wing {font-size: 0.5em; color: #fff; margin-left: -0.1em; position: relative; top: -0.7em}
  #logo .delim {color: #666}
  #desc {
    position: absolute; top: 90px; left: 25px;
    color: #fff; font-size: 22px; margin: 0; margin-left: 0.5em; margin-right: 7.5em; display: inline; font-weight: normal;
  }
  #info {color: #999; font-size: 20px; margin-left: 10px}
  #info:hover {color: #ccc}
  textarea {
    width: 545px; height: 700px;
    background: #2a211c; color: #fff;
    margin-bottom: 10px;
  }
  .bespin {
    border: 2px solid #4c4542;
    -webkit-box-shadow: 0px 0px 20px #222;
    -moz-box-shadow: 0px 0px 20px #222;
    box-shadow: 0px 0px 20px #222;
  }
  @-moz-document url-prefix() {.bespin .container {position: relative; top: -15px}}
  #errors {
    position: absolute; right: 8px; top: 132px; z-index: 1;
    background: #f00;
    padding: 10px;
    color: #fff;
    -webkit-box-shadow: 0px 0px 30px #000000;
    -moz-box-shadow: 0px 0px 30px #000000;
    box-shadow: 0px 0px 30px #000000;
  }
  #options {clear: left; margin-bottom: 10px}
  #options section {display: inline; margin-right: 20px}
  #options input[type=text] {font-size: 18px; border: 1px solid #333; width: 840px; padding: 5px; background: #2a211c; color: #ccc;}
"""

@sample = """
  doctype 5
  html ->
    head ->
      meta charset: 'utf-8'
      title "\#{@title or 'Untitled'} | My awesome website"
      meta(name: 'description', content: @desc) if @desc?
      link rel: 'stylesheet', href: '/stylesheets/app.css'
      style '''
        body {font-family: sans-serif}
        header, nav, section, footer {display: block}
      '''
      script src: '/javascripts/jquery.js'
      coffeescript ->
        $().ready ->
          alert 'Alerts are so annoying...'
    body ->
      header ->
        h1 @title or 'Untitled'
        nav ->
          ul ->
            (li -> a href: '/', -> 'Home') unless @path is '/'
            li -> a href: '/chunky', -> 'Bacon!'
            switch @user.role
              when 'owner', 'admin'
                li -> a href: '/admin', -> 'Secret Stuff'
              when 'vip'
                li -> a href: '/vip', -> 'Exclusive Stuff'
              else
                li -> a href: '/commoners', -> 'Just Stuff'
      section ->
        h2 "Let's count to \#{@max}:"
        p i for i in [1..@max]
      footer ->
        p shoutify('bye')
"""

template()
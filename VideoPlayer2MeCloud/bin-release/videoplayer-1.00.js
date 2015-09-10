(function (w, d) {
    // ensure load once
    if (w.MeCloudVideoPlayerLoaded)
        return;
    w.MeCloudVideoPlayerLoaded = true;
    var ua = function () {
        var doc = document, win = window, nav = navigator,
                UNDEF = "undefined",
                OBJECT = "object",
                SHOCKWAVE_FLASH = "Shockwave Flash",
                SHOCKWAVE_FLASH_AX = "ShockwaveFlash.ShockwaveFlash",
                FLASH_MIME_TYPE = "application/x-shockwave-flash";
        var w3cdom = typeof doc.getElementById !== UNDEF && typeof doc.getElementsByTagName !== UNDEF && typeof doc.createElement != UNDEF,
                u = nav.userAgent.toLowerCase(),
                p = nav.platform.toLowerCase(),
                windows = p ? /win/.test(p) : /win/.test(u),
                mac = p ? /mac/.test(p) : /mac/.test(u),
                webkit = /webkit/.test(u) ? parseFloat(u.replace(/^.*webkit\/(\d+(\.\d+)?).*$/, "$1")) : false,
                ie = !+"\v1", // 
                playerVersion = [0, 0, 0],
                d = null;
        if (typeof nav.plugins !== UNDEF && typeof nav.plugins[SHOCKWAVE_FLASH] === OBJECT) {
            d = nav.plugins[SHOCKWAVE_FLASH].description;
            if (d && !(typeof nav.mimeTypes !== UNDEF && nav.mimeTypes[FLASH_MIME_TYPE] && !nav.mimeTypes[FLASH_MIME_TYPE].enabledPlugin)) { 
                plugin = true;
                ie = false; 
                d = d.replace(/^.*\s+(\S+\s+\S+$)/, "$1");
                playerVersion[0] = parseInt(d.replace(/^(.*)\..*$/, "$1"), 10);
                playerVersion[1] = parseInt(d.replace(/^.*\.(.*)\s.*$/, "$1"), 10);
                playerVersion[2] = /[a-zA-Z]/.test(d) ? parseInt(d.replace(/^.*[a-zA-Z]+(.*)$/, "$1"), 10) : 0;
            }
        }
        else if (typeof win.ActiveXObject !== UNDEF) {
            try {
                var a = new ActiveXObject(SHOCKWAVE_FLASH_AX);
                if (a) { // a will return null when ActiveX is disabled
                    d = a.GetVariable("$version");
                    if (d) {
                        ie = true; // cascaded feature detection for Internet Explorer
                        d = d.split(" ")[1].split(",");
                        playerVersion = [parseInt(d[0], 10), parseInt(d[1], 10), parseInt(d[2], 10)];
                    }
                }
            }
            catch (e) {
            }
        }
        return {w3: w3cdom, pv: playerVersion, wk: webkit, ie: ie, win: windows, mac: mac};
    }(), callback = {};

    function getJSON(url, params, fn) {
        var cbName = (+new Date()) + "-cb-" + Math.floor(Math.random() * 10000);
        var e = d.createElement("script");
        params['callback'] = cbName;
        e.src = url + "?" + toParamStr(params);
        e.type = "text/javascript";
        callback[cbName] = fn;
        d.getElementsByTagName("head")[0].appendChild(e);
    }

    function makeRequest(url, fn, error) {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState === 4) {
                if (xmlhttp.status === 200) {
                    fn(xmlhttp.responseText);
                } else {
                    error();
                }
            }
        }
        xmlhttp.open("GET", url, true);
        xmlhttp.send();
    }

    function addEvent(element, eventName, fn) {
        if (element.addEventListener)
            element.addEventListener(eventName, fn, false);
        else if (element.attachEvent)
            element.attachEvent('on' + eventName, fn);
    }

    function fromParamStr(str) {
        var arr = str.split('&'), obj = {};
        for (var i = 0; i < arr.length; i++){
            var p = arr[i].split('=');
            obj[p[0]] = p[1]; 
        }
        return obj;
    }

    function attr(ele, attrName) {
        if (!ele || !ele.attributes[attrName])
            return null;
        return ele.attributes[attrName].value;
    }

    function toParamStr(obj) {
        var arr = [];
        for (var key in obj) {
            arr.push(key + "=" + escape(obj[key]));
        }
        return arr.join('&');
    }

    function normalizeData(data){
        data.isIframe = (w.top !== w);
    }

    function trigger(ev,data){
        if (handlers[ev] && handlers[ev].length){
            for (var i = 0; i < handlers[ev].length; i++)
                if (typeof handlers[ev][i] === 'function')
                    handlers[ev][i](data);
        }
    }

    var rfn = [], tracked = {}, sessData = {}, handlers = {}, isReady = false,
            coreFunc = {
                setData: function (session,data){
                    sessData[session] = data;
                },
                load: function (ele, data) {
                    normalizeData(data);
                    this.ready(function () {
                        if (ele && !ele.init)
                            return new MeCloudVideoPlayer(ele, data);
                    });
                },
                callback: function (name, data) {
                    if (callback[name] && typeof callback[name] === 'function') {
                        callback[name](data);
                        delete callback[name];
                    }
                },
                pageReady: function (fn) {
                    addEvent(w, "load", fn);
                },
                ready: function (fn) {
                    if (isReady)
                        fn();
                    else
                        rfn.push(fn);
                },
                getJSON: getJSON,
                makeRequest: makeRequest,
                initFlash: function (session) {
                    var e = d.getElementById('MeCloudVideoPlayer_Flash_' + session);
                    if (e && e.importData) {
                        e.importData(sessData[session]);
                    }
                },
                addEventListener: function(ev,handler){
                    if (!handlers[ev]) handlers[ev] = [];
                    handlers[ev].push(handler);
                },
                removeEventListener: function(ev,handler){
                    if (handlers[ev]){
                        if (!handler){
                            handlers[ev] = null;
                        } else {
                            for (var i = 0; i < handlers[ev].length; i++)
                                if (typeof handlers[ev][i] === 'function' && handlers[ev][i] == handler){
                                    handlers[ev].splice(i,1);
                                    return;
                                }
                        }
                    }
                },
                ping: function (vid, session, data) {
                    var e = d.getElementById('AnalyticsBridge_' + vid + '_' + session);
                    if (e && e.contentWindow) {
                        e.contentWindow.postMessage(JSON.stringify(data), "*");
                        var obj = fromParamStr(data.params);
                        switch (obj.ev){
                            case 'sv':
                                if (obj.play == 0)
                                    trigger('startview',{
                                        vid:vid, session:session, firstView:!tracked[session]
                                    });
                                break;
                            case 'ev':
                                var t = parseInt(obj.play);
                                if (Math.abs(sessData[session].duration - t) < 2000)
                                    trigger('complete',{
                                        vid:vid, session:session
                                    });
                                else {
                                    trigger('pause',{
                                        vid:vid, session:session
                                    });
                                }
                                break;
                        }
                        
                        if (!tracked[session] && obj.ev === 'p') {
                            tracked[session] = true;
                            setTimeout(function () {
                                (function (i, s, o, g, r, a, m) {
                                    i['GoogleAnalyticsObject'] = r;
                                    i[r] = i[r] || function () {
                                        (i[r].q = i[r].q || []).push(arguments)
                                    }, i[r].l = 1 * new Date();
                                    a = s.createElement(o);
                                    m = s.getElementsByTagName(o)[0];
                                    a.async = 1;
                                    a.src = g;
                                    m.parentNode.insertBefore(a, m)
                                })(w, d, 'script', '//www.google-analytics.com/analytics.js', 'ga');

                                ga('create', 'UA-62031737-3', 'auto');
                                ga('send', 'pageview');
                            }, 100);
                        }
                    }
                }
            };

    function loadHTML5() {
        w.MeCloudVideoPlayer = {
            coreFunc: coreFunc
        };
        for (var key in coreFunc)
            w.MeCloudVideoPlayer[key] = coreFunc[key];
        function loadScript(url, callback) {
            var r = d.querySelectorAll('script[src="' + url + '"]');
            if (r && r.length) {
                return;
            }
            var script = d.createElement('script');
            script.type = 'text/javascript';
            script.src = url;
            script.onreadystatechange = function () {
                if (this.readyState === 'complete' || this.readyState === 'loaded')
                    callback();
            };
            script.onload = callback;
            d.head.appendChild(script);
        }
        loadScript(w.$_VConfig.HTML5, function () {
            isReady = true;
            for (var i = 0; i < rfn.length; i++)
                rfn[i]();
            rfn = [];
        });
        
    }

    if (ua.pv[0] >= 10) { // use Flash
        w.MeCloudVideoPlayer = function (ele, data) {
            if (data.forceHTML5) {
                isReady = false;
                loadHTML5();
                MeCloudVideoPlayer.ready(function () {
                    MeCloudVideoPlayer.load(ele, data);
                });
                return;
            }
            var session = attr(ele, 'session');
            sessData[session] = data;
            var style = d.createElement("style");
            style.innerHTML = '#' + ele.id + ':before{padding-top:56.25% !important;content: "";display: block;padding-bottom: 30px;}';
            d.getElementsByTagName("head")[0].appendChild(style);
            var embed = d.createElement("embed");
            embed.id = 'MeCloudVideoPlayer_Flash_' + session;
            embed.src = w.$_VConfig.SWF;
            embed.setAttribute('flashvars', 'session=' + session);
            embed.setAttribute('quality', 'best');
            embed.setAttribute('allowScriptAccess', "always");
            embed.setAttribute('allowFullScreen', "true");
            embed.setAttribute('type', "application/x-shockwave-flash");
            embed.setAttribute('pluginspage', "http://www.adobe.com/go/getflash");
            embed.setAttribute('wmode','transparent');
            embed.style.setProperty('width', "100%", "important");
            embed.style.setProperty('height', "100%", "important");
            var bridge = d.createElement('iframe');
            bridge.id = 'AnalyticsBridge_' + data.vid + '_' + session;
            bridge.src = w.$_VConfig.ANALYTICS + "?session=" + session;
            bridge.style.setProperty('display', "none", "important");
            var box = d.createElement("div");
            box.id = 'MeCloudVideoPlayer_Container_' + session;
            box.className = 'memeplayer-flash-container';
            box.style.setProperty('top', "0", "important");
            box.style.setProperty('left', "0", "important");
            box.style.setProperty('right', "0", "important");
            box.style.setProperty('bottom', "0", "important");
            box.style.setProperty('position', "absolute");
            box.appendChild(embed);
            box.appendChild(bridge);
            ele.style.setProperty('position', "relative");
            ele.style.setProperty('overflow', "hidden");
            ele.appendChild(box);
        };
        for (var key in coreFunc)
            w.MeCloudVideoPlayer[key] = coreFunc[key];
        isReady = true;
        for (var i = 0; i < rfn.length; i++)
            rfn[i]();
        rfn = [];
    } else
        loadHTML5();

})(window, document);

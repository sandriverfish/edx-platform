window.includeUnicodeSpecs = (testFun) ->
    it "handles ASCII content", -> testFun(@, "This post contains ASCII.")
    it "handles Latin-1 content", -> testFun(@, "Thís pøst çòñtáins Lätin-1 tæxt")
    it "handles CJK content", -> testFun(@, "ｲんﾉ丂 ｱo丂ｲ co刀ｲﾑﾉ刀丂 cﾌズ")
    it "handles non-BMP content", -> testFun(@, "𝕋𝕙𝕚𝕤 𝕡𝕠𝕤𝕥 𝕔𝕠𝕟𝕥𝕒𝕚𝕟𝕤 𝕔𝕙𝕒𝕣𝕒𝕔𝕥𝕖𝕣𝕤 𝕠𝕦𝕥𝕤𝕚𝕕𝕖 𝕥𝕙𝕖 𝔹𝕄ℙ")
    it "handles content containing special characters", -> testFun(@, "\" This , post > contains < delimiter ] and [ other } special { characters ; that & may ' break things")
    it "handles content containing string interpolation syntax", -> testFun(@, 'This post contains %s string interpolation #{syntax}')

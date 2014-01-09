describe "NewPostInlineView", ->
    beforeEach ->
        setFixtures(
            """
            <div class="new-post-fixture">
                <form class="new-post-form">
                    <input type="text" class="new-post-title"/>
                    <div class="new-post-body"/>
                </form>
            </div>
            """
        )
        @view = new NewPostInlineView(el: $(".new-post-fixture"))

    describe "post submission", ->
        includeUnicodeSpecs (spec, content) ->
            spyOn($, "ajax").andCallFake((params) ->
                expect(params.data.title).toEqual(content)
                expect(params.data.body).toEqual(content)
                return {always: ->}
            )
            spec.view.$(".new-post-title").val(content)
            spec.view.$(".new-post-body .wmd-input").val(content)
            spec.view.$el.find(".new-post-form").submit()
            expect($.ajax).toHaveBeenCalled()

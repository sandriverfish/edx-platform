describe "DiscussionThreadView", ->
    beforeEach ->
        setFixtures(
            """
            <div class="thread-fixture"/>
            <script type="text/template" id="thread-template">
                <div class="thread-content-wrapper"/>
                <form>
                    <div class="reply-body" data-id="<%- id %>"/>
                    <button class="discussion-submit-post"/>
                </form>
            </script>
            <script type="text/template" id="thread-show-template"/>
            <script type="text/template" id="thread-edit-template">
                <form>
                    <input type="text" class="edit-post-title"/>
                    <div class="edit-post-body"/>
                    <button class="post-update">
                </form>
            </script>
            """
        )
        threadData = {
            id: "test-id",
            votes: {},
            abuse_flaggers: []
        }
        thread = new Thread(threadData)
        @view = new DiscussionThreadView(el: $(".thread-fixture"), model: thread)
        @view.render()

    describe "comment submission", ->
        includeUnicodeSpecs (spec, content) ->
            spyOn(spec.view, 'renderResponse') # Circumvent this to avoid additional setup
            spyOn($, "ajax").andCallFake((params) ->
                expect(params.data.body).toEqual(content)
                return {always: ->}
            )
            spec.view.setWmdContent("reply-body", content)
            spec.view.$el.find(".discussion-submit-post").click()
            expect($.ajax).toHaveBeenCalled()

    describe "content editing", ->
        includeUnicodeSpecs (spec, content) ->
            spyOn($, "ajax").andCallFake((params) ->
                expect(params.data.title).toEqual(content)
                expect(params.data.body).toEqual(content)
                return {always: ->}
            )
            spec.view.edit()
            spec.view.$el.find(".edit-post-title").val(content)
            spec.view.setWmdContent("edit-post-body", content)
            spec.view.$el.find(".post-update").click()
            expect($.ajax).toHaveBeenCalled()

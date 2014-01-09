describe "ThreadResponseView", ->
    beforeEach ->
        setFixtures(
            """
            <div class="response-fixture"/>
            <script type="text/template" id="thread-response-template">
                <div class="discussion-response"/>
                <form>
                    <div class="comment-body" data-id="<%- id %>"/>
                    <button class="discussion-submit-comment"/>
                </form>
            </script>
            <script type="text/template" id="thread-response-show-template"/>
            <script type="text/template" id="thread-response-edit-template">
                <form>
                    <div class="edit-post-body"/>
                    <button class="post-update">
                </form>
            </script>
            <script type="text/template" id="response-comment-show-template"/>
            """
        )
        commentData = {
            id: "test-id",
            votes: {},
            abuse_flaggers: []
        }
        comment = new Comment(commentData)
        @view = new ThreadResponseView(el: $(".response-fixture"), model: comment)
        @view.render()
        @view.afterInsert()

    describe "comment submission", ->
        includeUnicodeSpecs (spec, content) ->
            spyOn($, "ajax").andCallFake((params) ->
                expect(params.data.body).toEqual(content)
                return {always: ->}
            )
            spec.view.setWmdContent("comment-body", content)
            spec.view.$el.find(".discussion-submit-comment").click()
            expect($.ajax).toHaveBeenCalled()

    describe "content editing", ->
        includeUnicodeSpecs (spec, content) ->
            spyOn($, "ajax").andCallFake((params) ->
                expect(params.data.body).toEqual(content)
                return {always: ->}
            )
            spec.view.edit()
            spec.view.setWmdContent("edit-post-body", content)
            spec.view.$el.find(".post-update").click()
            expect($.ajax).toHaveBeenCalled()

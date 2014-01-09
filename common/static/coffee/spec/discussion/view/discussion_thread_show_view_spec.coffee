describe "DiscussionThreadShowView", ->
    beforeEach ->
        setFixtures(
            """
            <div class="discussion-post">
                <a href="#" class="vote-btn" data-tooltip="vote" role="button" aria-pressed="false">
                    <span class="plus-icon"/><span class="votes-count-number">0</span> <span class="sr">votes (click to vote)</span>
                </a>
            </div>
            <script type="text/template" id="thread-show-template">
                <div class="post-body"><%- body %></div>
            </script>
            """
        )

        @threadData = {
            id: "dummy",
            user_id: "567",
            course_id: "TestOrg/TestCourse/TestRun",
            body: "this is a thread",
            created_at: "2013-04-03T20:08:39Z",
            abuse_flaggers: [],
            votes: {up_count: "42"}
        }
        @thread = new Thread(@threadData)
        @view = new DiscussionThreadShowView({ model: @thread })
        @view.setElement($(".discussion-post"))
        window.user = new DiscussionUser({id: "567", upvoted_ids: []})

    it "renders the vote correctly", ->
        DiscussionViewSpecHelper.checkRenderVote(@view, @thread)

    it "votes correctly", ->
        DiscussionViewSpecHelper.checkVote(@view, @thread, @threadData, true)

    it "unvotes correctly", ->
        DiscussionViewSpecHelper.checkUnvote(@view, @thread, @threadData, true)

    it 'toggles the vote correctly', ->
        DiscussionViewSpecHelper.checkToggleVote(@view, @thread)

    it "vote button activates on appropriate events", ->
        DiscussionViewSpecHelper.checkVoteButtonEvents(@view)

    describe "content rendering", ->
        includeUnicodeSpecs (spec, content) ->
            spec.thread.set({body: content})
            spec.view.render()
            expect(spec.view.$el.find(".post-body").text()).toEqual(content)

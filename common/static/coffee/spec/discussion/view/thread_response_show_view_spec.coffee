describe "ThreadResponseShowView", ->
    beforeEach ->
        setFixtures(
            """
            <div class="discussion-post">
                <a href="#" class="vote-btn" data-tooltip="vote" role="button" aria-pressed="false">
                    <span class="plus-icon"/><span class="votes-count-number">0</span> <span class="sr">votes (click to vote)</span>
                </a>
            </div>
            <script type="text/template" id="thread-response-show-template">
                <div class="response-body"><%- body %></div>
            </script>
            """
        )

        @commentData = {
            id: "dummy",
            user_id: "567",
            course_id: "TestOrg/TestCourse/TestRun",
            body: "this is a comment",
            created_at: "2013-04-03T20:08:39Z",
            abuse_flaggers: [],
            votes: {up_count: "42"}
        }
        @comment = new Comment(@commentData)
        @view = new ThreadResponseShowView({ model: @comment })
        @view.setElement($(".discussion-post"))
        window.user = new DiscussionUser({id: "567", upvoted_ids: []})
        DiscussionUtil.loadRoles({Administrator: [], Moderator: [], "Community TA": []})

    it "renders the vote correctly", ->
        DiscussionViewSpecHelper.checkRenderVote(@view, @comment)

    it "votes correctly", ->
        DiscussionViewSpecHelper.checkVote(@view, @comment, @commentData, true)

    it "unvotes correctly", ->
        DiscussionViewSpecHelper.checkUnvote(@view, @comment, @commentData, true)

    it 'toggles the vote correctly', ->
        DiscussionViewSpecHelper.checkToggleVote(@view, @comment)

    it "vote button activates on appropriate events", ->
        DiscussionViewSpecHelper.checkVoteButtonEvents(@view)

    describe "content rendering", ->
        includeUnicodeSpecs (spec, content) ->
            spec.comment.set({body: content})
            spec.view.render()
            expect(spec.view.$el.find(".response-body").text()).toEqual(content)

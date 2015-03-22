APP.Chatroom = function () {
    var websocketPostsChannel = new WebSocketRails(APP.websocketEndpoint).subscribe('posts');
    var commentsSection = $(".user_posts");


    var updateOnNewComment = function () {
        websocketPostsChannel.bind('new', function(post) {
            commentsSection.prepend($(post).fadeIn());
            commentsSection.scrollTop(0);
        });
    }

    return{
        updateOnNewComment: updateOnNewComment
    };
};

APP.CommentBox = function () {
    var submitButton = $('#post_comment');
    var inputTextArea = $('#user_comment');

    var errorSection = $('#comment_error');
    var emptyCommentErrorMsg = 'Cannot post empty message';
    var serverErrorPostingComment = 'Something went wrong posting your comment. Try again.';

    var postOnClick = function () {
        submitButton.click(function () {
            validateAndCallServer();
        });
        return APP.CommentBox();
    }

    var postOnEnterKeypress = function(){
        inputTextArea.keypress(function(e) {
            if(e.which == 13) {
                validateAndCallServer();
            }
        });
        return APP.CommentBox();
    }

    function validateAndCallServer(){
        inputTextArea.prop('disabled', true);
        var message = inputTextArea.val();
        if (message === "") {
            errorSection.text(emptyCommentErrorMsg).show();
        }
        else{
            $.ajax({
                type: "POST",
                url: '/chatroom',
                data: {
                    message: $('#user_comment').val()
                },
                success: function (data) {
                    errorSection.hide();
                    inputTextArea.val('');
                    inputTextArea.prop('disabled', false);
                },
                error: function () {
                    errorSection.text(serverErrorPostingComment).show();
                    inputTextArea.prop('disabled', false);
                }
            });
        }
    }

    return{
        postOnClick: postOnClick,
        postOnEnterKeypress: postOnEnterKeypress
    };
}

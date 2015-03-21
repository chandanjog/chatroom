APP.Chatroom = function(){
    var websocketPostsChannel = new WebSocketRails(APP.websocketEndpoint).subscribe('posts')

    var updateOnNewComment = function(){
        websocketPostsChannel.bind('new', function(post) {
            var post_markup = $('#user_post').clone();
            post_markup.find('img.post_dialect').attr('src', function(){
                return '/assets/' + post.dialect + '.ico';
            });
            post_markup.find('.post_username').html(post.username + '<small class="text-muted post_created_at">' + moment(post.created_at).format("dddd, MMMM Do YYYY, h:mm:ss a") + '</small>');
            post_markup.find('.post_message').text(post.message);
            $(".user_posts").prepend(post_markup.show());
        });
    }

    return{
        updateOnNewComment: updateOnNewComment
    };
};

APP.CommentBox = function(){
    var submitButton = $('#post_comment');
    var inputTextArea = $('#user_comment');

    var errorSection = $('#comment_error');
    var emptyCommentErrorMsg = 'Cannot post empty message';
    var serverErrorPostingComment = 'Something went wrong posting your comment. Try again.';

    var postOnClick = function(){
        submitButton.click(function(){
            var message = inputTextArea.val();
            if(message === ""){
                errorSection.text(emptyCommentErrorMsg).show();
            }
            else{
                $.ajax({
                    type: "POST",
                    url: '/chatroom',
                    data: {
                        message: $('#user_comment').val()
                    },
                    success: function(data){
                        errorSection.hide();
                    },
                    error: function(){
                        errorSection.text(serverErrorPostingComment).show();
                    }
                });
            }
        });
    }

    return{
        postOnClick: postOnClick
    };
}

$(document).ready(function(){
    var dispatcher = new WebSocketRails('localhost:3000/websocket');
    var channel = dispatcher.subscribe('posts');
    channel.bind('new', function(post) {
        var post_markup = $('#user_post').clone();
        post_markup.find('img.post_dialect').attr('src', function(){
            return '/assets/' + post.dialect + '.ico';
        });
        post_markup.find('.post_username').html(post.username + '<small class="text-muted post_created_at">' + moment(post.created_at).format("dddd, MMMM Do YYYY, h:mm:ss a") + '</small>');
        post_markup.find('.post_message').text(post.message);
        $(".user_posts").append(post_markup.show());
    });

    $('#post_comment').click(function(){
        var message = $('#user_comment').val();
        if(message === ""){
            $('#comment_error').text('Cannot post empty message').show();
        }
        else{
            $.ajax({
                type: "POST",
                url: '/chatroom',
                data: {
                    message: $('#user_comment').val()
                },
                success: function(data){
                    $('#comment_error').hide();
                },
                error: function(){
                    $('#comment_error').text('Something went wrong posting your comment. Try again.').show();
                }
            });
        }
    });
});

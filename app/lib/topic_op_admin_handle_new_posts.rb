# frozen_string_literal: true

DiscourseEvent.on(:post_created) do |*params|
  return unless SiteSetting.topic_op_admin_enabled

  post, opt, user = params

  if TopicOpBannedUser.isBanned?(post.topic_id, user.id)
    if SiteSetting.topic_op_admin_delete_post_instead_of_hide?
      PostDestroyer.new(Discourse.system_user, post).destroy
    else
      post.hide!(1, custom_message: "silenced_by_topic_OP")
    end
  end
end

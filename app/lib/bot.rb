# frozen_string_literal: true

module TopicOpUserAdminBot
  def TopicOpUserAdminBot.getBot()
    User.find_by(id: SiteSetting.topic_op_admin_bot_user_id?) || Discourse.system_user
  end

  def TopicOpUserAdminBot.botLogger(rawText)
    if SiteSetting.topic_op_admin_enable_topic_log?
      PostCreator.create!(
        getBot,
        topic_id: SiteSetting.topic_op_admin_logger_topic?,
        raw: rawText,
        guardian: Guardian.new(Discourse.system_user),
        import_mode: true,
      )
    end
  end

  def TopicOpUserAdminBot.botSendPost(topic_id, rawText, **opts)
    PostCreator.create!(getBot, topic_id: topic_id, raw: rawText, guardian: Guardian.new(Discourse.system_user), **opts)
  end
end

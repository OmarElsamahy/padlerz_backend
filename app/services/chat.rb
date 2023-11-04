class Chat
  def create_chat_room(chat_attributes, members)
    members = members.unshift({ user_id: chat_attributes[:user_id], user_type: chat_attributes[:user_type] })
                     .uniq { |member| { user_id: member[:user_id], user_type: member[:user_type] } }

    if members.count == 2
      return @existing_chat if direct_chat_exists?(members.pluck(:user_id, :user_type))
      chat_attributes[:is_direct_chat] = true
    end
    @chat_room = ChatRoom.new(chat_attributes)
    @chat_room.chat_members.build(members)
    @chat_room.save
    return @chat_room
  end

  def update_chat_room(chat_room, chat_attributes, members) #for groups only
    members = members.unshift({ user_id: chat_attributes[:user_id] }).uniq { |member| member[:user_id] }
    chat_room.update(chat_attributes)
    chat_room.users = Customer.where(id: members.pluck(:user_id))
    return chat_room
  end

  def direct_chat_exists?(users)
    @existing_chat = ((Object.const_get users[0][1]).find(users[0][0]).chat_rooms.direct &
                      (Object.const_get users[1][1]).find(users[1][0]).chat_rooms.direct).first
  end
end

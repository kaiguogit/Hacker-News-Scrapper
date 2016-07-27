class Comment

  attr_reader :comment, :user, :age

  def initialize(user, age, comment)
    @user = user
    @age = age
    @comment = comment
  end
end
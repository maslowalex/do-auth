defmodule DoAuth.UserTest do
  use ExUnit.Case, async: true
  use Bamboo.Test

  alias Uptight.Result
  alias Uptight.Text, as: T
  alias DoAuth.User
  alias DoAuth.Credential

  describe "reserve_identity/3" do
    setup do
      %Result.Ok{ok: email} = T.new("user@mail.com")
      %Result.Ok{ok: nickname} = T.new("user")

      %{email: email, nickname: nickname}
    end

    test "with unused email allows to reserve identity", %{email: %T{text: email_text} = email, nickname: nickname} do
      %Result.Ok{ok: hostname} = T.new("do_auth.com")
      %Result.Ok{ok: pid} = User.reserve_identity(email, nickname, homebase: hostname)

      assert is_pid(pid)

      assert %{
        email: ^email,
        nickname: ^nickname,
        cred: %Uptight.Base.Urlsafe{} = cred,
      } = :sys.get_state(pid)

      assert %{"credentialSubject" => %{"email" => ^email_text}} = DoAuth.Credential.tip(cred)

      assert_email_delivered_with(subject: "Welcome to do_auth.com, #{nickname.text}!")
    end

    # TODO: How to wipe our credential store correctly?
    # test "with reserved identity - returns an error", ctx do
    #   User.reserve_identity(ctx.email, ctx.nickname)

    #   assert %Result.Err{err: %Uptight.Trace{
    #     exception: %Uptight.AssertionError{
    #       message: msg
    #     }}} = User.reserve_identity(ctx.email, ctx.nickname)

    #   assert msg == "The user with E-mail #{ctx.email.text} is already registered."
    # end
  end
end

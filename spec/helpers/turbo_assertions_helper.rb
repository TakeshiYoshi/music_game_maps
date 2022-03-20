module TurboAssertionsHelper
  TURBO_VISIT = /Turbo\.visit\("([^"]+)", {"action":"([^"]+)"}\)/

  def assert_redirected_to(options = {}, message = nil)
    if turbo_request?
      assert_turbo_visited(options, message)
    else
      super
    end
  end

  def assert_turbo_visited(options = {}, message = nil)
    assert_response(:ok, message)
    assert_equal("text/javascript", response.try(:media_type) || response.content_type)

    visit_location, _ = turbo_visit_location_and_action

    redirect_is       = normalize_argument_to_redirection(visit_location)
    redirect_expected = normalize_argument_to_redirection(options)

    message ||= "Expected response to be a Turbo visit to <#{redirect_expected}> but was a visit to <#{redirect_is}>"
    assert_operator redirect_expected, :===, redirect_is, message
  end

  # 「Content-Typeがtext/javascriptの非GETリクエスト」かどうかという
  # 簡単なヒューリスティックでTurbolinksのリクエストを検出する
  #
  # 技術的にはTurbolinks-Referrerリクエストヘッダが設定されていることも
  # チェックするが、そのためには`turbo:`オプションを指定して
  # POSTやPATCHなどのテストメソッドのヘッダーをオーバーライドして渡す
  # 必要がある
  #
  # `request.xhr?`チェックは利用できない
  # （X-Requested-Withヘッダーは、後続のリクエストで漏洩しないよう
  # コントローラのアクション実行後にクリアされるため）
  def turbo_request?
    !request.get? && (response.try(:media_type) || response.content_type) == "text/javascript"
  end

  def turbo_visit_location_and_action
    if response.body =~ TURBO_VISIT
      [ $1, $2 ]
    end
  end
end

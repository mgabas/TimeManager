defmodule Todolist.JwtAuthToken do
    use Joken.Config
    require Logger

    def verifyToken(token_with_claims) do
        verify = Todolist.JwtAuthToken.verify(token_with_claims)
        if Enum.at(Tuple.to_list(verify), 0) == :ok do
            Logger.debug "Verify token says: true"
            True
        else
            Logger.debug "Verify token says: false"
            False
        end
    end

end
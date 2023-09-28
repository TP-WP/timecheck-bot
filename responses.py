def handle_response(message) -> str:
    p_message = message.lower()

    if p_message == "hello there":
        return "general kenobi"

    if p_message == "!help":
        return "`help message`"
    
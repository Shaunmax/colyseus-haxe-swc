package io.colyseus.error;

class MatchMakeError {
    public var code: Int;
    public var message: String;

    public function new(code: Int, message: String) {
        this.code = code;
        this.message = message;
    }
}

#! VULNERABLE variant — imports the centralized capabilities and calls a sink with the
#! untrusted body directly, skipping the extract boundary. check -> UNSAFE: the checker
#! follows taint across the module, so centralizing capabilities cannot hide the misuse.
import capabilities

let body = fetch<web>
commit { release(body) }  # tainted -> sink: REJECTED

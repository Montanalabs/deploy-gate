#! deploy-gate — a HYBRID injection-safe service. Privilege is centralized in
#! capabilities.os; each feature is a self-contained vertical slice (its own closed type +
#! extract boundary + attenuated sink); and even the router extracts the untrusted route
#! into a closed set. Untrusted data only ever reaches a sink after clearing extract.
import router

route()

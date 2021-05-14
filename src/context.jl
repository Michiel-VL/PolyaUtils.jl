Cassette.@context MetaheuristicLogging

function Cassette.overdub(ctx::MetaheuristicLogging, f::typeof(Polya.Δ), args...)
    logger = ctx.metadata
    ret = @timed f(args...)
    log!(logger, args[2], ret.value[2], ret.time)
    return ret.value
end
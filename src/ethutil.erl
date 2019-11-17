-module(ethutil).

-export([integer/1]).
-export([difficulty/1]).
-export([blocktime/1]).
-export([hashrate/2]).

-spec integer(N :: binary() | integer()) -> binary() | integer().
integer(<<"0x", N/binary>>) -> binary_to_integer(N, 16);
integer(N) when is_integer(N) -> <<"0x", (integer_to_binary(N, 16))/binary>>.

-spec difficulty(Values :: [non_neg_integer()]) -> float().
difficulty(Values) ->
    lists:sum(Values) / 100.

-spec blocktime(Timestamps :: [non_neg_integer()]) -> float().
blocktime([]) -> 0;
blocktime(Timestamps) ->
    F = fun({Current, Next}, Acc) -> Acc + (Next - Current) end,
    lists:foldl(F, 0, make_timestamp_pair(Timestamps, [])) / length(Timestamps).

hashrate(Difficulty, BlockTime) ->
    Difficulty / BlockTime.

make_timestamp_pair([], Acc) -> Acc;
make_timestamp_pair([_TS], Acc) -> Acc;
make_timestamp_pair([TS | Rest], Acc) ->
    make_timestamp_pair(Rest, [{TS, hd(Rest)} | Acc]).

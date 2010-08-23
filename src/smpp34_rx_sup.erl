
-module(smpp34_rx_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_child/1, start_child/2]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, temporary, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Socket) ->
	start_child(Socket, self()).

start_child(Socket, PduSink) ->
	supervisor:start_child(?MODULE, [self(), Socket, PduSink]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, { {simple_one_for_one, 5, 10}, [?CHILD(smpp34_rx, worker)]} }.


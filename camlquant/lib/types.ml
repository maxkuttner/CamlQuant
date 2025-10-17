(*
Wait, young one — before you can manage a portfolio, your saving or anything in
the finacial world (that consititutes an investment-like transaction), you 
shall define the vectorspace of financial investments fully and precisely.

At its core, finance is about making investment decisions. 
An instrument is a financial contract — a stock, bond, derivative, or any tradeable asset. 
Each instrument has unique properties and rules that govern how it behaves.
A leg represents a single slice of an investment decision. 
It captures everything you need to enter a trade with a counterparty: which instrument, at what price, and in what quantity.
A position is a complete investment decision, composed of one or more legs. 
A simple long stock position has one leg; a more complex strategy like 
an option straddle (or any other combination of options) 
has multiple legs across different strikes and expirations.
A strategy is a container for investments. It can hold positions directly, or 
it can hold other strategies—creating a hierarchy. 
This recursion gives us a high degree of flexibility: whether you're modeling a 
single long stock, a multi-leg options strategy, a trading fund, 
or an entire investment firm with multiple sub-funds, they all fit the 
same structure. Ultimately, a portfolio is just a strategy at the top level — a 
collection of investment decisions, nested however you need.
*)



(* ============================================
   INSTRUMENTS
   ============================================ *)

type instrument_id = string

type stock_spec = {
  symbol: string;
}

type option_type = Call | Put

type option_spec = {
  underlying_id: instrument_id;
  strike: float;
  expiration: string;
  option_type: option_type;
}

type instrument =
  | Stock of stock_spec
  | Option of option_spec
  (*| Bond of bond_spec*)


(* ============================================
   POSITIONS
   ============================================ *)


type side = Long | Short

type leg = {
  instrument: instrument;
  side: side;
  quantity: float;
  entry_price: float;
  entry_date: string;
}

type position_status =
  | Open
  | Closed of close_reason

(* having a close reason might be an overkill at this point 
-> for now lets consider the default to be a manual close 
-> other reasons might include: expiration, stoploss, ... *)
and close_reason =
  | Manual of string

type position = {
  id: string;
  description: string;
  legs: leg list;
  status: position_status;
}


(* ============================================
   STRATEGY: RECURSIVE
   ============================================ *)

type strategy = {
  id: string;
  name: string;
  contents: strategy_item list;
}

and strategy_item =
  | Position of position
  | Strategy of strategy
module sui_token_contract::basic_token {
    use sui::coin::{Self, TreasuryCap};
    use sui::object::new;
    use sui::transfer::public_freeze_object;
    use sui::transfer::public_transfer;
    use std::option::none;

    public struct BASIC_TOKEN has drop {}

    public struct MinterCap has key, store {
        id: sui::object::UID,
        treasury_cap: TreasuryCap<BASIC_TOKEN>
    }



    fun init(witness: BASIC_TOKEN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            witness,
            8, // decimals
            b"BTKN", // symbol
            b"Basic Token", // name
            b"Description of the Basic Token", // description
            none(), // icon url
            ctx
        );

        public_freeze_object(metadata);
        let minter_cap = MinterCap {
            id: new(ctx),
            treasury_cap
        };

        public_transfer(minter_cap, ctx.sender());

    }
    // treasury_cap: &mut TreasuryCap<MY_COIN>,
	// 	amount: u64,
	// 	recipient: address,
	// 	ctx: &mut TxContext,

    public entry fun mint( minter_cap: &mut MinterCap, amount: u64, recipient: address, ctx: &mut TxContext) {
        let new_coin = coin::mint(&mut minter_cap.treasury_cap, amount, ctx);
        public_transfer(new_coin, recipient);
    }

    public entry fun transfer_token(
        coin: coin::Coin<BASIC_TOKEN>,
        recipient: address,
    ){
        public_transfer(coin, recipient);
    }

     public entry fun burn(
        minter_cap: &mut MinterCap,
        coin: coin::Coin<BASIC_TOKEN>
    ) {
        coin::burn(&mut minter_cap.treasury_cap, coin);
    }




}


#include <eosiolib/eosio.hpp>

using namespace eosio;

class pingpong : public eosio::contract {
  public:
      using contract::contract;

      /// @abi action
      void ping( account_name user ) {
         print( "Pong, ", name{user} );
      }
};

EOSIO_ABI( pingpong, (ping) )

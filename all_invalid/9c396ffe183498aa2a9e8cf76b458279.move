let res = move_from<Resource>(signer::address_of(&s));
let Resource { id: _ } = res;  // explicitly consume 'res'

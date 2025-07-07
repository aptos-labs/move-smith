let res = borrow_global<Resource>(signer::address_of(&s));
let Resource { id: _ } = *res; // explicitly consume the dereferenced resource

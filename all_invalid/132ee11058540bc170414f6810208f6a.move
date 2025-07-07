let s3 = S { x: s2.x, y: s2.y };
// let mut s3_mut = s3;
modify_by_ref(&mut s3);
no_modify(&s3);
s3.x + s3.y
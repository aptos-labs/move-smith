use proc_macro::TokenStream;
use quote::quote;
use syn::{parse_macro_input, Data, DeriveInput, Fields};

#[proc_macro_derive(VariantConversions)]
pub fn variant_conversions(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as DeriveInput);

    let name = &input.ident;
    let variants = match &input.data {
        Data::Enum(data_enum) => &data_enum.variants,
        _ => panic!("AutoConversions can only be derived for enums"),
    };

    let mut try_into_impls = Vec::new();
    let mut from_impls = Vec::new();

    for variant in variants {
        let variant_name = &variant.ident;

        // Ensure the variant has exactly one field
        let ty = match &variant.fields {
            Fields::Unnamed(fields) if fields.unnamed.len() == 1 => {
                &fields.unnamed.first().unwrap().ty
            },
            _ => panic!("Each variant must have exactly one unnamed field"),
        };

        // Generate TryInto implementation
        try_into_impls.push(quote! {
            impl TryInto<#ty> for #name {
                type Error = &'static str;

                fn try_into(self) -> Result<#ty, Self::Error> {
                    if let #name::#variant_name(value) = self {
                        Ok(value)
                    } else {
                        Err(concat!("Not a ", stringify!(#variant_name), " variant"))
                    }
                }
            }
        });

        // Generate From implementation
        from_impls.push(quote! {
            impl From<#ty> for #name {
                fn from(value: #ty) -> Self {
                    #name::#variant_name(value)
                }
            }
        });
    }

    let expanded = quote! {
        #(#try_into_impls)*
        #(#from_impls)*
    };

    TokenStream::from(expanded)
}

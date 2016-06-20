//
//  FPSigning.h
//  FirePrime
//
//  Created by Perceval FARAMAZ on 20.06.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#ifndef FPSigning_h
#define FPSigning_h

/*
 * THREAD SAFETY: crypto_sign_keypair() is thread-safe,
 * provided that you called sodium_init() once before using any
 * other libsodium function.
 * Other functions, including crypto_sign_seed_keypair() are always thread-safe.
 */

#define crypto_sign_BYTES 64U

#define crypto_sign_SEEDBYTES 32U

#define crypto_sign_PUBLICKEYBYTES 32U

#define crypto_sign_SECRETKEYBYTES (32U + 32U)

#define crypto_sign_PRIMITIVE "ed25519"

int crypto_sign_seed_keypair(unsigned char *pk, unsigned char *sk,
                             const unsigned char *seed);

int crypto_sign_keypair(unsigned char *pk, unsigned char *sk);

int crypto_sign(unsigned char *sm, unsigned long long *smlen_p,
                const unsigned char *m, unsigned long long mlen,
                const unsigned char *sk);

int crypto_sign_open(unsigned char *m, unsigned long long *mlen_p,
                     const unsigned char *sm, unsigned long long smlen,
                     const unsigned char *pk)
__attribute__ ((warn_unused_result));

int crypto_sign_detached(unsigned char *sig, unsigned long long *siglen_p,
                         const unsigned char *m, unsigned long long mlen,
                         const unsigned char *sk);

int crypto_sign_verify_detached(const unsigned char *sig,
                                const unsigned char *m,
                                unsigned long long mlen,
                                const unsigned char *pk)
__attribute__ ((warn_unused_result));

#endif /* FPSigning_h */

use gadget_sdk as sdk;
use sdk::job;
use std::convert::Infallible;

use methods::PROGRAM_GUEST_ELF;
use risc0_ethereum_contracts::groth16::encode;

use alloy_sol_types::{sol, SolValue};
use risc0_zkvm::{compute_image_id, default_prover, ExecutorEnv, ProverOpts};

// Ethereum types for job
sol! {
    struct JobInputs {
        bytes journalData;
        bytes seal;
    }
}

#[job(id = 0, params(x), result(_), verifier(evm = "ZkvmBlueprint"))]
pub fn xsquare(x: u64) -> Result<Vec<u8>, Infallible> {
    let env = ExecutorEnv::builder()
        .write(&(x as u32))
        .unwrap()
        .build()
        .unwrap();

    // Obtain the default prover.
    let prover = default_prover();

    // TODO: Get logger working
    log::info!(target: "gadget", "Proving job");
    // Proof information by proving the specified ELF binary.
    let prove_info: risc0_zkvm::ProveInfo = prover.prove(env, PROGRAM_GUEST_ELF).unwrap();
    log::info!(target: "gadget", "Proof generation successful, now compressing into Groth16 proof...");

    let receipt = prove_info.receipt;
    let opts = ProverOpts::groth16();
    let compressed = prover.compress(&opts, &receipt).unwrap();

    log::info!(target: "gadget", "Compressed proof to Groth16.");

    let image_id = compute_image_id(PROGRAM_GUEST_ELF).unwrap();

    compressed.verify(image_id).unwrap();
    log::info!(target: "gadget", "Groth16 proof verified.");

    let seal = encode(compressed.inner.groth16().unwrap().seal.clone()).unwrap();
    let journal = compressed.journal.bytes;

    let job_inputs = JobInputs {
        journalData: journal.into(),
        seal: seal.into(),
    };

    // ABI encode the struct
    let encoded_inputs = job_inputs.abi_encode();

    log::info!(target: "gadget", "Responding to job request with proof.");
    Ok(encoded_inputs)
}

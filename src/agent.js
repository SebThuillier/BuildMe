import { Actor, HttpAgent } from "@dfinity/agent"
import { idlFactory as buildme_idl, canisterId as buildme_id } from "dfx-generated/buildme"

const agentOptions = {
  host: "http://localhost:8000",
}

const agent = new HttpAgent(agentOptions)
const buildme = Actor.createActor(buildme_idl, { agent, canisterId: buildme_id })

export { buildme }
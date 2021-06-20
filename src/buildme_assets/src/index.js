import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory as buildme_idl, canisterId as buildme_id } from 'dfx-generated/buildme';

const agent = new HttpAgent();
const buildme = Actor.createActor(buildme_idl, { agent, canisterId: buildme_id });

document.getElementById("clickMeBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  const greeting = await buildme.greet(name);

  document.getElementById("greeting").innerText = greeting;
});

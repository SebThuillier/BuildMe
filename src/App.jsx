import React, { useCallback, useEffect, useState } from "react"
import logo from "./assets/logo.svg"
import "./App.css"
import { buildme } from "./agent"
import  Projects  from "./components/Projects"
import Tabs from 'react-bootstrap/Tabs';
import Tab from 'react-bootstrap/Tab';

function App() {
  const nonVotedProjects_test = {id: 1, projectName: "foo"};
  const votedProjects_test = {id: 2, projectName: "bar"};
  
  const [nonVotedProjects, setNonVotedProjects] = useState(nonVotedProjects_test)
  const [votedProjects, setVotedProjects] = useState(votedProjects_test)

  const refreshCounter = useCallback(async () => {
    // const res = await counter.getValue()
    // setCount(res.toString())
  }, [])

  useEffect(() => {
    refreshCounter()
  }, [])

  const onIncrementClick = useCallback(async () => {
    // await counter.increment()
    // refreshCounter()
  }, [])

  function addProject() {
    
  }

  function editProject() {

  }

  return (
    <main>
      <div className="px-4 py-5 my-5">
        <div className="text-center">
          <h1 className="display-5 fw-bold">Let's build something together</h1>
          <div className="col-lg-6 mx-auto">
            <p className="lead mb-4">Community driven projects are advantageous for the health, growth and adoption of a network, and wow are the projects exciting! Yet many developers are unable to participate because they're individuals without a clear project idea, or are waiting for some particular answers to unblock them. Let's enable the community to drive projects together with BuildMe.</p>
          </div>
        </div>

        <div className="col-lg-6 mx-auto">
          <h6>Here's how this is going to work:</h6>
          <ol>
            <li>Add projects you like (please no duplicates!)</li>
            <li>You may vote up or down on each project (or don’t vote)</li>
            <li>The top 5 options with the most votes (upvotes - downvotes) will be available for final voting</li>
            <li>We’ll all help build the project with the most votes!</li>
          </ol>
        </div>

        <div className="col-lg-6 mx-auto">Voting for the top 5 projects begins Sunday August 1, 2021 @ 12am UTC</div>
        <div className="col-lg-6 mx-auto">Final voting on the top project begins Wednesday September 1, 2021 @ 12am UTC</div>


        <Tabs defaultActiveKey="non-voted-projects" id="project-tabs">
          <Tab eventKey="non-voted-projects" title="Projects I haven't voted on">
            <Projects projects={nonVotedProjects} voted={false} />
          </Tab>
          <Tab eventKey="voted-projects" title="Projects I've voted on">
            <Projects projects={votedProjects} voted={true} />
          </Tab>
        </Tabs>


        <div>
          <button className="btn btn-primary" onClick={addProject}>
            Add New Project
          </button>
        </div>

      </div>
    </main>
  );
}

export default App

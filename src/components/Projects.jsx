import React, { useEffect, useRef, useState } from "react";

function Projects(props) {
  return (
    <table className="table table-striped table-bordered">
      {<tbody>
        {Object.entries(props).map(
          proj =>
            <tr key={proj[1].id}>
              <td>
                < input name="name" value={proj[1].projectName} type="text"
                  />
              </td>
              <td>
                <button onClick={() => editProject(proj[1].id)} className="btn btn-info">View</button>
              </td>
              <td>
                <button onClick={() => editProject(proj[1].id)} className="btn btn-info">Upvotes</button>
              </td>
              <td>
                <button onClick={() => editProject(proj[1].id)} className="btn btn-info">Downvotes</button>
              </td>
            </tr>
        )}
      </tbody>}
    </table>
  )
}

export default Projects;
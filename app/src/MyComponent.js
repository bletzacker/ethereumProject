import React from "react";
import { newContextComponents } from "@drizzle/react-components";
import logo from "./logo.png";

const { AccountData, ContractData, ContractForm } = newContextComponents;

export default ({ drizzle, drizzleState }) => {
  return (
    <div className="App">

      <div>
        <h1>Decentralized UBER</h1>
        <p>
          Educational project carried out for EMURGO training
        </p>
      </div>

      <div className="section">
        <h2>Active Account</h2>
          <AccountData
          drizzle={drizzle}
          drizzleState={drizzleState}
          accountIndex={0}
          units="ether"
          precision={4}
          />
          <strong>Name as customer : </strong>
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="Uber"
            method="readCustomerName"
          />
          <p></p>
          <strong>Name as driver : </strong>
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="Uber"
            method="readDriverName"
          />
          <p></p>
          <strong>Uber Token : </strong>
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="Uber"
            method="balanceUBER"
            methodArgs={[drizzleState.accounts[0]]}
          />{" "}
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="UberToken"
            method="symbol"
            hideIndicator
          />

      </div>

      <div class="row">
        <div class="column">
          <div className="section">
            <h2>Customer</h2>
            <ContractForm
              drizzle={drizzle}
              contract="Uber"
              method="registerCustomer"
              labels={["Name"]}
              sendArgs={{from: drizzleState.accounts[0], value: 10**17}}
              render={({ inputs, inputTypes, state, handleInputChange, handleSubmit }) => (
                <form onSubmit={handleSubmit}>
                  {inputs.map((input, index) => (
                    <input
                      style={{ fontSize: 20,  margin: '10px'}}
                      key={input.name}
                      type={inputTypes[index]}
                      name={input.name}
                      value={state[input.name]}
                      placeholder={"Name"}  //placeholder={input.name}
                      onChange={handleInputChange}
                    />
                  ))}
                  <button
                    key="submit"
                    type="button"
                    onClick={handleSubmit}
                    style={{ fontSize: 20 }}
                  >
                    Register
                  </button>
                </form>
              )}
            />
            <p></p>
            <ContractForm
              drizzle={drizzle}
              contract="Uber"
              method="updateCustomer"
              labels={["New name"]}
              render={({ inputs, inputTypes, state, handleInputChange, handleSubmit }) => (
                <form onSubmit={handleSubmit}>
                  {inputs.map((input, index) => (
                    <input
                      style={{ fontSize: 20, margin: '10px' }}
                      key={input.name}
                      type={inputTypes[index]}
                      name={input.name}
                      value={state[input.name]}
                      placeholder={"New name"}  //placeholder={input.name}
                      onChange={handleInputChange}
                    />
                  ))}
                  <button
                    key="submit"
                    type="button"
                    onClick={handleSubmit}
                    style={{ fontSize: 20 }}
                  >
                    Update
                  </button>
                </form>
              )}
            />
            <p></p>
            <ContractForm
              drizzle={drizzle}
              contract="Uber"
              method="unregisterCustomer"
              render={({ inputs, inputTypes, state, handleInputChange, handleSubmit }) => (
                <form onSubmit={handleSubmit}>
                  {inputs.map((input, index) => (
                    <input
                      style={{ fontSize: 20}}
                      key={input.name}
                      type={inputTypes[index]}
                      name={input.name}
                      value={state[input.name]}
                      placeholder={input.name}
                      onChange={handleInputChange}
                    />
                  ))}
                  <button
                    key="submit"
                    type="button"
                    onClick={handleSubmit}
                    style={{ fontSize: 20 }}
                  >
                    Unregister
                  </button>
                </form>
              )}
            />
          </div>

          <div className="section">
            <h2>Ride to : </h2>
            <ContractForm
              drizzle={drizzle}
              contract="Uber"
              method="sendRide"
              labels={["pickup_lat","pickup_long","destination_lat","destination_long"]}
              render={({ inputs, inputTypes, state, handleInputChange, handleSubmit }) => (
                <form onSubmit={handleSubmit}>
                  {inputs.map((input, index) => (
                    <input
                      style={{ fontSize: 20 , margin: '20px'}}
                      key={input.name}
                      type={inputTypes[index]}
                      name={input.name}
                      value={state[input.name]}
                      placeholder={input.name}
                      onChange={handleInputChange}
                    />
                  ))}
                  <button
                    key="submit"
                    type="button"
                    onClick={handleSubmit}
                    style={{ fontSize: 20 }}
                  >
                    Send
                  </button>
                </form>
              )}
            />
            <p></p>
            <ContractForm
              drizzle={drizzle}
              contract="Uber"
              method="cancelRide"
              labels={["Name"]}
              render={({ inputs, inputTypes, state, handleInputChange, handleSubmit }) => (
                <form onSubmit={handleSubmit}>
                  {inputs.map((input, index) => (
                    <input
                      style={{ fontSize: 20 }}
                      key={input.name}
                      type={inputTypes[index]}
                      name={input.name}
                      value={state[input.name]}
                      placeholder={input.name}
                      onChange={handleInputChange}
                    />
                  ))}
                  <button
                    key="submit"
                    type="button"
                    onClick={handleSubmit}
                    style={{ fontSize: 20 }}
                  >
                    Cancel
                  </button>
                </form>
              )}
            />
            <p></p>
            <ContractForm
              drizzle={drizzle}
              contract="Uber"
              method="comfirmRide"
              labels={["Name"]}
              render={({ inputs, inputTypes, state, handleInputChange, handleSubmit }) => (
                <form onSubmit={handleSubmit}>
                  {inputs.map((input, index) => (
                    <input
                      style={{ fontSize: 20 }}
                      key={input.name}
                      type={inputTypes[index]}
                      name={input.name}
                      value={state[input.name]}
                      placeholder={input.name}
                      onChange={handleInputChange}
                    />
                  ))}
                  <button
                    key="submit"
                    type="button"
                    onClick={handleSubmit}
                    style={{ fontSize: 20 }}
                  >
                    Confirm Arrival
                  </button>
                </form>
              )}
            />
          </div>
        </div>
        
        <div class="column">
          <div className="section">
            <h2>Driver</h2>
            <ContractForm
              drizzle={drizzle}
              contract="Uber"
              method="registerDriver"
              labels={["Name"]}
              sendArgs={{from: drizzleState.accounts[0], value: 5 * 10**17}}
              render={({ inputs, inputTypes, state, handleInputChange, handleSubmit }) => (
                <form onSubmit={handleSubmit}>
                  {inputs.map((input, index) => (
                    <input
                      style={{ fontSize: 20 }}
                      key={input.name}
                      type={inputTypes[index]}
                      name={input.name}
                      value={state[input.name]}
                      placeholder={"Name"}  //placeholder={input.name}
                      onChange={handleInputChange}
                    />
                  ))}
                  <button
                    key="submit"
                    type="button"
                    onClick={handleSubmit}
                    style={{ fontSize: 20 }}
                  >
                    Register
                  </button>
                </form>
              )}
            />
            <p></p>
            <ContractForm
              drizzle={drizzle}
              contract="Uber"
              method="updateDriver"
              labels={["New name"]}
              render={({ inputs, inputTypes, state, handleInputChange, handleSubmit }) => (
                <form onSubmit={handleSubmit}>
                  {inputs.map((input, index) => (
                    <input
                      style={{ fontSize: 20 }}
                      key={input.name}
                      type={inputTypes[index]}
                      name={input.name}
                      value={state[input.name]}
                      placeholder={"New name"}  //placeholder={input.name}
                      onChange={handleInputChange}
                    />
                  ))}
                  <button
                    key="submit"
                    type="button"
                    onClick={handleSubmit}
                    style={{ fontSize: 20 }}
                  >
                    Update
                  </button>
                </form>
              )}
            />
            <p></p>
            <ContractForm
              drizzle={drizzle}
              contract="Uber"
              method="unregisterDriver"
              labels={["Name"]}
              render={({ inputs, inputTypes, state, handleInputChange, handleSubmit }) => (
                <form onSubmit={handleSubmit}>
                  {inputs.map((input, index) => (
                    <input
                      style={{ fontSize: 20 }}
                      key={input.name}
                      type={inputTypes[index]}
                      name={input.name}
                      value={state[input.name]}
                      placeholder={input.name}
                      onChange={handleInputChange}
                    />
                  ))}
                  <button
                    key="submit"
                    type="button"
                    onClick={handleSubmit}
                    style={{ fontSize: 20 }}
                  >
                    Unregister
                  </button>
                </form>
              )}
            />
          </div>

          <div className="section">
            <h2>Take a ride </h2>
            <ContractData
              drizzle={drizzle}
              drizzleState={drizzleState}
              contract="Uber"
              method="getRides"
              />
            <ContractForm
              drizzle={drizzle}
              contract="Uber"
              method="startRide"
              labels={["Ride address"]}
              render={({ inputs, inputTypes, state, handleInputChange, handleSubmit }) => (
                <form onSubmit={handleSubmit}>
                  {inputs.map((input, index) => (
                    <input
                      style={{ fontSize: 20 , margin: '20px'}}
                      key={input.name}
                      type={inputTypes[index]}
                      name={input.name}
                      value={state[input.name]}
                      placeholder={"Ride address"}  //placeholder={input.name}
                      onChange={handleInputChange}
                    />
                  ))}
                  <button
                    key="submit"
                    type="button"
                    onClick={handleSubmit}
                    style={{ fontSize: 20 }}
                  >
                    Start
                  </button>
                </form>
              )}
            />
            <p></p>
            <ContractForm
              drizzle={drizzle}
              contract="Uber"
              method="endRide"
              labels={[""]}
              render={({ inputs, inputTypes, state, handleInputChange, handleSubmit }) => (
                <form onSubmit={handleSubmit}>
                  {inputs.map((input, index) => (
                    <input
                      style={{ fontSize: 20 }}
                      key={input.name}
                      type={inputTypes[index]}
                      name={input.name}
                      value={state[input.name]}
                      placeholder={input.name}
                      onChange={handleInputChange}
                    />
                  ))}
                  <button
                    key="submit"
                    type="button"
                    onClick={handleSubmit}
                    style={{ fontSize: 20 }}
                  >
                    End
                  </button>
                </form>
              )}
            />
          </div>

        </div>
      </div> 
  
    </div>
  );
};

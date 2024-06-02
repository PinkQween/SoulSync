import { useState } from "react";
import { PayPalScriptProvider, PayPalButtons, ReactPayPalScriptOptions } from "@paypal/react-paypal-js";

// Renders errors or successful transactions on the screen.
const Message: React.FC<{ content: string }> = ({ content }) => {
  return <p>{content}</p>;
}

const App = () => {
  const initialOptions: ReactPayPalScriptOptions = {
    "client-id": import.meta.env.VITE_PP_CLIENT,
    "enable-funding": "paylater,venmo",
    "data-sdk-integration-source": "integrationbuilder_sc",
  };

  const [message, setMessage] = useState("");

  return (
    <div className="App">
      <PayPalScriptProvider options={initialOptions}>
        <PayPalButtons
          style={{
            shape: "rect",
            layout: "vertical", // Default value. Can be changed to horizontal
          }}
          createOrder={async () => {
            try {
              const response = await fetch("/api/orders", {
                method: "POST",
                headers: {
                  "Content-Type": "application/json",
                },
                body: JSON.stringify({
                  cart: [
                    {
                      id: "LCT",
                      quantity: 666,
                    },
                    {
                      id: "LRT",
                      quantity: 777,
                    },
                  ],
                }),
              });

              const orderData = await response.json();

              if (orderData.id) {
                return orderData.id;
              } else {
                const errorDetail = orderData?.details?.[0];
                const errorMessage = errorDetail
                  ? `${errorDetail.issue} ${errorDetail.description} (${orderData.debug_id})`
                  : JSON.stringify(orderData);

                throw new Error(errorMessage);
              }
            } catch (error) {
              console.error(error);
              setMessage(`Could not initiate PayPal Checkout... ${error.message}`);
              throw error;
            }
          }}
          onApprove={async (data, actions) => {
            try {
              const details = await actions.order.capture();
              setMessage("Transaction completed by " + details.payer.name.given_name);
            } catch (error) {
              console.error(error);
              setMessage(`Could not capture PayPal Checkout... ${error.message}`);
            }
          }}
          onError={(err) => {
            console.error(err);
            setMessage(`An error occurred during PayPal Checkout... ${err.message}`);
          }}
          onCancel={() => {
            setMessage("Payment cancelled.");
          }}
        />
      </PayPalScriptProvider>
      <Message content={message} />
    </div>
  );
}

export default App;

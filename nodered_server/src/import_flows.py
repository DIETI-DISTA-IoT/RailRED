import requests
import json

"""
This works from the host because of port mapping..
"""

def import_flows(flows_file, node_red_url='http://127.0.0.1:1880'):
    # Read the flows from the JSON file
    with open(flows_file, 'r') as file:
        flows = json.load(file)
    
    print(flows)

    # Node-RED Admin API endpoint for flows
    api_url = f"{node_red_url}/flows"

    # Send the POST request to import flows
    response = requests.post(api_url, json=flows)

    if response.status_code == 200:
        print("Flows imported successfully!")
    else:
        print(f"Failed to import flows. Status code: {response.status_code}")
        print(f"Response: {response.text}")

if __name__ == "__main__":
    # Wait for Node-RED to start (adjust the time if needed)
    # time.sleep(10)
    
    # Path to your flows JSON file
    flows_file = 'nodered_server/TCMS.json'
    
    # Import the flows
    import_flows(flows_file)
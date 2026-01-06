import re

def colorize_bpmn_professional(file_path, output_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Professional Palette: Formal Presentation Mode
    colors = {
        # Navy & Sky Blue (Tasks/Activities)
        'Activity_': 'bioc:stroke="#0D47A1" color:background-color="#E3F2FD"', 
        # Deep Amber (Decision Gateways)
        'Gateway_': 'bioc:stroke="#FF8F00" color:background-color="#FFF8E1"',  
        # Forest Green (Events)
        'Event_': 'bioc:stroke="#2E7D32" color:background-color="#E8F5E9"',    
        # Slate Gray (The 'System' Pool)
        'Participant_0pv6jd6': 'bioc:stroke="#455A64" color:background-color="#F8F9FA"' 
    }

    # Inject colors into the DI (Diagram Interchange) section
    for key, color_attr in colors.items():
        # This regex targets the BPMNShape definitions in the XML
        pattern = rf'(<bpmndi:BPMNShape [^>]*bpmnElement="{key}[^"]*"[^>]*)>'
        content = re.sub(pattern, r'\1 ' + color_attr + '>', content)

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(content)

# Execute the conversion
colorize_bpmn_professional('the-Complete-One(3).bpmn', 'Formal-Presentation-BPMN.bpmn')
print("Conversion complete! Your diagram now uses a formal presentation theme.")

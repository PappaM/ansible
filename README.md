# ansible
My ansible playbooks and roles

Alle settings die ik op alle servers wil, worden gezet en onderhouden door playbook baseline.yml .
Om een baseline te kunnen draaien moet er een user 'ansible' aanweizg zijn die sudo zonder password kan doen, en waar ik met sshkey's kan aanloggen. Dat doet add-user-ansible.yml .

Op raspberry pi's moeten eerst nog wat pi specifieke settings gebeuren. Dat doet playbook init-pi.yml . De user ansible moet er al zijn, dus eerst playbook add-user-ansible.yml draaien.

Playbook add-user-ansible.yml heeft user root, of een user met sudo-zonder-password nodig om de accout te kunnen maken. Pas dit aan in de variable aan het begin van het playbook. Gebruik optie -k (--ask-pass) zodat het ansible-playbook command om het wachtwoord vraagt. Dat hoeft het niet in de plain in het playbook gezet te worden.

using System.Collections;
using System.Collections.Generic;
using UnityEditor.Animations;
using UnityEngine;

public class playerMovement : MonoBehaviour
{
    // Start is called before the first frame update
    Transform gun;
    Vector2 screenCenter;
    float angDif;
    public Object bullet;
    public float velocity;
    void Start()
    {
        gun = transform.GetChild(1);
        screenCenter = new Vector2(Screen.width/2, Screen.height/2);
    }

    // Update is called once per frame
    void Update()
    {
        GunPosition();
    }

    void GunPosition(){

        angDif = Vector3.Angle(Input.mousePosition - (Vector3)screenCenter, new Vector3(1f, 0f, 0f));
        gun.position = (Input.mousePosition - (Vector3)screenCenter).normalized / 2;

        if (gun.position.x < 0)
        {
            gun.GetComponent<SpriteRenderer>().flipY = true;
        }
        else 
        {
            gun.GetComponent<SpriteRenderer>().flipY = false;
        }

        if (gun.position.y < 0)
        {
            angDif *=-1;
        }

        gun.eulerAngles = new Vector3(0f, 0f, angDif);

        if (Input.GetMouseButtonDown(0)) 
        {
            GameObject instanse = (GameObject) Instantiate(bullet);
            instanse.transform.position = transform.position + gun.position;
            instanse.transform.rotation = gun.rotation;
            instanse.GetComponent<Rigidbody2D>().velocity = gun.position * velocity; 
        } 
    }
}

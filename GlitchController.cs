using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GlitchController : MonoBehaviour
{
	[SerializeField] private Material shaderMaterial;
	[SerializeField] public bool isGlitching = false;
	[SerializeField] private AudioSource audioSource;
	[SerializeField] private AudioClip soundEffect;
	private bool playingSound = false;
	
	void Start() {
		shaderMaterial.SetFloat("_IsGlitching", 0.0f);
		//soundEffect = audioSource.GetComponent<AudioClip>();
	}

    void Update() {
		if (isGlitching) {
			if (!playingSound) {
				audioSource.PlayOneShot(soundEffect, 1f);
				playingSound = true;
			}
			shaderMaterial.SetFloat("_IsGlitching", 1.0f);
		}
		else {
			shaderMaterial.SetFloat("_IsGlitching", 0.0f);
			playingSound = false;
		}
	}

	// turns off glitching after some given time
	public IEnumerator glitchCoroutine(float glitchTime) {
		yield return new WaitForSeconds(glitchTime);
		isGlitching = false;
	}
}
